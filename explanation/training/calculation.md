---
layout: newocr
title: Calculation
description: How character separation works during training in NewOCR.
keywords: Calculation, Sorting, Character Segmentation
parent: Training
grand_parent: Explanation
nav_order: 3
permalink: /explanation/training/calculation
github-path: explanation/training/calculation.md
---

# Character Calculation

Arguably the most important step in the OCR, the system next needs to derive the data it's going to store in the database.

## Character Segmentation

{% include calculation.md %}

## Storing The Data

After the data is calculated for each character, <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/2dcf3f19c218e233943dbaf12361f54eea8bb472/src/main/java/com/uddernetworks/newocr/recognition/OCRTrain.java#L247-L252">the 16 data points are separately averaged with all other characters, and then the resulting points are stored in the database.</src>

## Font Sizes

If the option is enabled, font sizes may be stored in the database as well to detect the size of the scanned font during scanning. When a character is iterated over during training, the current line's font size is divided by the height of the character. All of each character's results of this are averaged and the single number per character us stored in the database. This way, it can be multiplied by the scanned character's height and the result will be the font size.

