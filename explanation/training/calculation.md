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

After the data is calculated for each character, <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/OCRTrain.java#L180-L185">the 16 data points are separately averaged with all other characters, and then the resulting points are stored in the database.</src>

