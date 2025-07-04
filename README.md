# PDF to JPG (Lubuntu Edition)

Convert selected pages from any PDF file into high-quality JPG images with a simple graphical interface and real-time export log.  
Designed for **Linux (Lubuntu/XFCE)** environments and optimized for office use across multiple computers.

## Features

- Convert specific pages (e.g. `1-3,5,9`) or all pages with `"all"`
- Clean output: `page-1.jpg`, `page-2.jpg`, ...
- Skips already exported pages
- Handles invalid page numbers gracefully
- Shows **graphical input prompts** via `zenity`
- Displays **live export log** via `yad`
- Automatically checks for new version and updates from GitHub
- Auto-closes when done — no terminal needed
- Works from **right-click menu on PDF files**
- Automatically downloads the app icon if missing and places it in the correct folder (`~/.local/share/icons/`).

## Requirements

Ensure the following packages are installed:

```bash
sudo apt install zenity poppler-utils yad curl
```

## Installation

1. **Download or clone the repository:**

```bash
git clone https://github.com/hmartinov/PDF-to-JPG.git
cd PDF-to-JPG
```

2. **Make the installation script executable and run it:**

```bash
chmod +x install.sh
./install.sh
```

The script will:
- Automatically install required tools (`zenity`, `yad`, `pdftoppm`, `pdfinfo`, `curl`)
- Copy the main script to `~/bin/`
- Register `.desktop` launcher so the tool appears in the right-click menu for PDF files

## Output

- Images are saved in a folder named like the PDF:  
  `/home/user/Documents/File.pdf/File/page-1.jpg`, `page-2.jpg`, ...

- Already existing images are skipped to avoid re-exporting.

## Example usage

Launch the script from your file manager’s right-click menu or run it manually:

```bash
~/bin/pdf_to_jpg.sh /home/user/Documents/file.pdf
```
## Ideal for

- Office computers running Lubuntu/XFCE
- Automating image exports for scanned PDFs
- Users who prefer GUI over terminal commands

## Download

Get the latest version from the [release](https://github.com/hmartinov/PDF-to-JPG/releases) folder.

## Changelog

See full release history in the [CHANGELOG.md](./CHANGELOG.md) file.

## License

MIT License – free for personal and commercial use.

## Author

H. Martinov  
[hmartinov@dmail.ai](mailto:hmartinov@dmail.ai)  
[GitHub](https://github.com/hmartinov/PDF-to-JPG)

---

_See instructions and update info directly in the app menu._
