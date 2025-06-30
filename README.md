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
- Auto-closes when done — no terminal needed
- Works from **right-click menu on PDF files**

##  Requirements

Ensure the following packages are installed:

```bash
sudo apt install zenity poppler-utils yad
```

## Installation

1. **Copy the script** to a safe path like:  
   `~/bin/pdf_to_jpg.sh`

2. **Make it executable:**

```bash
chmod +x ~/bin/pdf_to_jpg.sh
```

3. **(Optional)** Add a `.desktop` file to integrate it into the file manager’s right-click menu.

## Output

- Images are saved in a folder named like the PDF:  
  `/path/to/YourFile_pdf/page-1.jpg`, `page-2.jpg`, ...

- Already existing images are skipped to avoid re-exporting.

## Auto-updates (coming soon)

The script will soon support **automatic version checking and self-updating** via GitHub.

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

See the full list of changes in the [CHANGElOG.md](./CHANGELOG.md) file.

## License

MIT License – free for personal and commercial use.

## Author

H. Martinov  
[hmartinov@dmail.ai](mailto:hmartinov@dmail.ai)  
[GitHub](https://github.com/hmartinov/PDF-to-JPG)

---

_See instructions and details in the app menu._
