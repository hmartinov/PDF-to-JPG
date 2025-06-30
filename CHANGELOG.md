# Changelog

All notable changes to this project will be documented in this file.

---

## [1.1] – 2024-06-27  
### Added
- Live log window during export using `yad`
- Automatic detection and skipping of already exported pages
- Input support for full ranges and mixed selection (e.g. `1-3,5,9`)
- "all" keyword to export entire PDF in one go
- Page validation and error messaging for invalid selections
- Clean structured output in `page-<num>.jpg` format
- Automatic version checking and self-updating via GitHub

### Fixed
- Prevented re-export of existing pages
- Better formatting of final result messages
- Stability improvements for edge cases

---

## [1.0] – 2024-06-25  
### Initial release
- Extract selected PDF pages as JPG
- Simple GUI input using `zenity`
- Output to subfolder named after the PDF file
- Basic error handling
