#!/bin/bash

# Настройки
INSTALL_DIR="$HOME/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
SCRIPT_NAME="pdf_to_jpg.sh"
DESKTOP_FILE="pdf-to-jpg.desktop"

# Списък с нужните инструменти
REQUIRED=("pdftoppm" "pdfinfo" "curl" "zenity" "yad")

echo "== PDF to JPG инсталация =="
echo

# 1. Проверка за sudo
if [[ $EUID -ne 0 ]]; then
  echo "🔐 За инсталацията ще трябва администраторска парола (sudo)."
fi

# 2. Проверка за нужните пакети
echo "⏳ Проверка за нужните зависимости..."
for pkg in "${REQUIRED[@]}"; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
        echo "📦 Липсва: $pkg – ще бъде инсталиран..."
        sudo apt-get update
        sudo apt-get install -y "$pkg"
    else
        echo "✅ Наличен: $pkg"
    fi
done

# 3. Създаване на папки
mkdir -p "$INSTALL_DIR"
mkdir -p "$DESKTOP_DIR"

# 4. Копиране на файловете
echo
echo "📂 Копиране на файловете..."
cp "$SCRIPT_NAME" "$INSTALL_DIR/"
cp "$DESKTOP_FILE" "$DESKTOP_DIR/"

# 5. Даване на права за изпълнение
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$DESKTOP_DIR/$DESKTOP_FILE"

#6. Опресняване на менюто
update-desktop-database "$DESKTOP_DIR"
if command -v lxpanelctl >/dev/null 2>&1; then
    lxpanelctl restart
fi

# 7. Финално съобщение
echo
echo "✅ Инсталацията приключи успешно!"
echo "👉 Програмата вече е достъпна при отваряне на PDF файл с десен бутон."
echo
read -p "Натисни Enter за изход..."
