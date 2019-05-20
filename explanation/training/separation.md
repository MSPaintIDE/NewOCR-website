---
layout: newocr
title: Separation
description: How character separation works during training in NewOCR.
keywords: Separation, Character Separation, Line Separation
parent: Training
grand_parent: Explanation
nav_order: 2
permalink: /explanation/training/separation
github-path: explanation/training/separation.md
---

# Character Separation

Character separation is the very first step in how the OCR works, where a similar process occurs during scanning. character separation allows each character to be broken into a separate group to perform future data calculation on.

Please note that <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/2dcf3f19c218e233943dbaf12361f54eea8bb472/src/main/java/com/uddernetworks/newocr/recognition/OCRTrain.java#L116">this process does happen after binarization of the image,</src> where in many OCRs would be paired with other preprocessing (Usually for dealing with natural images, which NewOCR does not support).

## Line Separation

{% include line-separation.md %}

## Character Separation

After each line is separated, the characters can be extracted. <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/2dcf3f19c218e233943dbaf12361f54eea8bb472/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L114-L126">From a line, all touching black pixels are grouped together, and all vertically overlapping groups are grouped together in a list for each overlapping group.</src> <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/2dcf3f19c218e233943dbaf12361f54eea8bb472/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L136-L183">Each list is then ordered by Y value, and iterated through where each part is given an incrementing *modifier*, which is the same for every part of a character. It is also given the character from the known string in the training file later on.</src>

<src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/2dcf3f19c218e233943dbaf12361f54eea8bb472/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L165-L177">If any characters require distance checks, such as the distance between a dot of a character and its base, the space between an <code>=</code>, <code>:</code>, etc. then it is calculated by the distance of the part and the base, divided by the height of the base. This allows for the distance to be highly scalable, as fonts' spacing ratios don't change when scaled.</src> This calculated value is set as a meta value, which is averaged and put in the database in the future.