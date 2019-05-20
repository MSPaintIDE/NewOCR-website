---
layout: newocr
title: Spacing
description: How spacing works during scanning in NewOCR.
keywords: Spacing, Character
parent: Scanning
grand_parent: Explanation
nav_order: 4
permalink: /explanation/scanning/spacing
github-path: explanation/scanning/spacing.md
---

# Spacing

Spacing is a process to add spaces between characters. This is a process that can be hard to get right, especially if it's vital to get correct in some instances.

Spacing starts off with getting the space width ratio gathered between the two `W`'s during training. The system then iterates through all the letter lines gotten by the OCR, and gets the gap between each character in pixels (Or from the beginning of the image to the first character). If a character requires a custom space, it is fetched in this loop as well and is set to be the distance ratio instead of the normal space.

<src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/2dcf3f19c218e233943dbaf12361f54eea8bb472/src/main/java/com/uddernetworks/newocr/recognition/OCRScan.java#L188-L202">This space ratio is multiplied by the maximum height of the characters in the current line, and the amount of times this value can fit in the gap of the two characters adds to the total spaces.</src> <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/2dcf3f19c218e233943dbaf12361f54eea8bb472/src/main/java/com/uddernetworks/newocr/recognition/OCRScan.java#L231-L236">If the remaining pixels equate to more than 20% of a space, it is added to the amount of spaces.</src> <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/2dcf3f19c218e233943dbaf12361f54eea8bb472/src/main/java/com/uddernetworks/newocr/recognition/OCRScan.java#L217-L219">After the final space value is calculated, space letters are inserted at correct X and Y positions with correct dimensions.</src>

After spacing is calculated, characters are re-ordered to ensure they are correctly placed, and the scanning is complete.