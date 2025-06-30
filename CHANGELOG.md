# Changelog

All notable changes to this project will be documented in this file.

---

## [1.1] – 2024-06-27  
### Added
- Automated installation script (`install.sh`) for seamless setup
- Dependency checker and installer for required tools
- Live log window during export using `yad`
- Automatic detection and skipping of already exported pages
- Input support for full ranges and mixed selection (e.g. `1-3,5,9`)
- "all" keyword to export the entire PDF
- Version check and auto-update functionality via GitHub
- Proper user feedback with grouped page ranges and final result summary

### Fixed
- Prevented re-export of existing pages
- Improved user experience and error handling
- Better layout and icon for desktop integration

---

## [1.0] – 2024-06-25  
### Initial release
- Extract selected PDF pages as JPG
- Simple GUI input using `zenity`
- Output to subfolder named after the PDF file
- Basic error handling
