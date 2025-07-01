#!/bin/bash

VERSION="1.1"
REPO_URL="https://raw.githubusercontent.com/hmartinov/PDF-to-JPG/main"
SCRIPT_URL="https://github.com/hmartinov/PDF-to-JPG/releases/latest/download/pdf_to_jpg.sh"
SCRIPT_PATH="$HOME/bin/pdf_to_jpg.sh"

# Проверка за нова версия
REMOTE_VERSION=$(curl -fs "$REPO_URL/version.txt" 2>/dev/null | tr -d '\r\n ')

if [[ -n "$REMOTE_VERSION" && "$REMOTE_VERSION" != "$VERSION" ]]; then
    zenity --question \
        --title="Налична е нова версия" \
        --text="Имате версия $VERSION.\nНалична е нова версия: $REMOTE_VERSION\n\nИскате ли да я изтеглите сега?"
    if [[ $? -eq 0 ]]; then
        TMPFILE=$(mktemp)
        if curl -fsSL "$SCRIPT_URL" -o "$TMPFILE"; then
            mv "$TMPFILE" "$SCRIPT_PATH"
            chmod +x "$SCRIPT_PATH"
            zenity --info --title="Обновено" --text="Скриптът беше обновен успешно до версия $REMOTE_VERSION."
            exec "$SCRIPT_PATH" "$@"
            exit 0
        else
            zenity --error --title="Грешка" --text="Неуспешно изтегляне на новата версия."
            rm -f "$TMPFILE"
        fi
    fi
fi

# Проверка за зависимости
MISSING=()
REQUIRED=("pdftoppm" "pdfinfo" "zenity" "yad" "curl")

for cmd in "${REQUIRED[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        MISSING+=("$cmd")
    fi
done

if (( ${#MISSING[@]} > 0 )); then
    zenity --error --title="Липсващи зависимости" --text="Следните инструменти не са инсталирани:\n${MISSING[*]}"
    exit 1
fi

FILE="$1"

if [[ "${FILE##*.}" != "pdf" ]]; then
    zenity --error --title="Грешен формат" --text="Избраният файл не е PDF файл."
    exit 1
fi

TOTAL=$(pdfinfo "$FILE" | grep "Pages" | awk '{print $2}')

PAGES=$(zenity --entry --title="PDF към JPG" --text="Страници за експортиране (напр. 1-3,5,7 или all):")
PAGES=$(echo "$PAGES" | tr -d '[:space:]')  # премахва интервали

if [[ -z "$PAGES" ]]; then
    PAGES="all"
fi

group_ranges() {
    local arr=($(printf '%s\n' "$@" | sort -n))
    local output=""
    local start=${arr[0]}
    local end=$start
    for (( i=1; i<${#arr[@]}; i++ )); do
        if (( arr[i] == end + 1 )); then
            end=${arr[i]}
        else
            if (( start == end )); then
                output+="$start,"
            else
                output+="$start-$end,"
            fi
            start=${arr[i]}
            end=$start
        fi
    done
    if (( start == end )); then
        output+="$start"
    else
        output+="$start-$end"
    fi
    echo "$output"
}

BASENAME=$(basename "$FILE" .pdf)
OUTPUT_DIR="$(dirname "$FILE")/${BASENAME}_jpg"
mkdir -p "$OUTPUT_DIR"

PAGE_LIST=()
if [[ "${PAGES,,}" == "all" ]]; then
    for (( i=1; i<=TOTAL; i++ )); do
        PAGE_LIST+=("$i")
    done
else
    IFS=',' read -ra PARTS <<< "$PAGES"
    for PART in "${PARTS[@]}"; do
        if [[ "$PART" == *"-"* ]]; then
            START=${PART%-*}
            END=${PART#*-}
            for (( i=START; i<=END; i++ )); do
                PAGE_LIST+=("$i")
            done
        else
            PAGE_LIST+=("$PART")
        fi
    done
fi

EXPORTED=0
SKIPPED=()
INVALID=()

LOG_PIPE="/tmp/pdf_export_log_$$"
mkfifo "$LOG_PIPE"

yad --title="Експортиране на PDF страници" \
    --width=600 --height=300 \
    --text-info \
    --fontname="Monospace 10" \
    --center \
    --tail < "$LOG_PIPE" &
LOG_PID=$!
exec 3> "$LOG_PIPE"

for i in "${PAGE_LIST[@]}"; do
    if (( i >= 1 && i <= TOTAL )); then
        OUTFILE="${OUTPUT_DIR}/page-${i}.jpg"
        if [[ -f "$OUTFILE" ]]; then
            SKIPPED+=("$i")
        else
            pdftoppm -jpeg -singlefile -f "$i" -l "$i" "$FILE" "$OUTPUT_DIR/tmp_page" >/dev/null 2>&1
            if [[ -f "${OUTPUT_DIR}/tmp_page.jpg" ]]; then
                mv "${OUTPUT_DIR}/tmp_page.jpg" "$OUTFILE"
                echo "$OUTFILE" >&3
                ((EXPORTED++))
            else
                echo "❌ Неуспех при извличане на страница $i" >&3
            fi
        fi
    else
        INVALID+=("$i")
    fi
done

exec 3>&-
sleep 0.5
kill "$LOG_PID" 2>/dev/null
wait "$LOG_PID" 2>/dev/null
rm -f "$LOG_PIPE"

if [[ "$PAGES" =~ ^[0-9]+$ ]] && [[ "${#SKIPPED[@]}" -eq 1 ]] && [[ "$EXPORTED" -eq 0 ]]; then
    zenity --info --title="Информация" --text="ℹ️ Страница $PAGES съществува и не е извлечена."
    exit 0
fi

RANGE_ALL=$(group_ranges "${PAGE_LIST[@]}")
RANGE_SKIPPED=$(group_ranges "${SKIPPED[@]}")
RANGE_INVALID=$(group_ranges "${INVALID[@]}")

if (( EXPORTED > 0 )); then
    MSG="📤 Обработени страници: $RANGE_ALL\n\n📁 Файловете се намират в:\n$OUTPUT_DIR"
    if (( ${#SKIPPED[@]} > 0 )); then
        MSG+="\n\nℹ️ Следните страници вече съществуват и не бяха извлечени повторно: $RANGE_SKIPPED"
    fi
    if (( ${#INVALID[@]} > 0 )); then
        MSG+="\n\n⚠️ Невалидни страници (файлът има $TOTAL): $RANGE_INVALID"
    fi
    zenity --info --title="Готово!" --text="$(echo -e "$MSG")"

elif (( EXPORTED == 0 && ${#SKIPPED[@]} > 0 )); then
    MSG="ℹ️ Всички избрани страници вече съществуват:\n$RANGE_SKIPPED"
    zenity --info --title="Няма нужда от действие" --text="$(echo -e "$MSG")"

elif (( ${#INVALID[@]} > 0 )); then
    MSG="⚠️ Невалидни страници (файлът има $TOTAL):\nВъведена грешна стойност: $RANGE_INVALID"
    zenity --error --title="Грешка" --text="$(echo -e "$MSG")"

else
    zenity --error --title="Грешка" --text="Нито една от въведените страници не съществува и няма какво да се извлече."
fi
