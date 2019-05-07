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

Please note that <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/OCRTrain.java#L60">this process does happen after binarization of the image,</src> where in many OCRs would be paired with other preprocessing (Usually for dealing with natural images, which NewOCR does not support).

## Line Separation

{% include line-separation.md %}

## Character Separation

After each line is separated, the characters can be extracted. <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/7aa211108c8da4d7900b4e89442b1a003dfe1c3e/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L97-L109">From a line, all touching black pixels are grouped together, and all vertically overlapping groups are grouped together in a list for each overlapping group.</src> <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/7aa211108c8da4d7900b4e89442b1a003dfe1c3e/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L119-L166">Each list is then ordered by Y value, and iterated through where each part is given an incrementing *modifier*, which is the same for every part of a character. It is also given the character from the known string in the training file later on.</src>

<src data-gh="https://github.com/RubbaBoy/NewOCR/blob/7aa211108c8da4d7900b4e89442b1a003dfe1c3e/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L148-L160">If any characters require distance checks, such as the distance between a dot of a character and its base, the space between an <code>=</code>, <code>:</code>, etc. then it is calculated by the distance of the part and the base, divided by the height of the base. This allows for the distance to be highly scalable, as fonts' spacing ratios don't change when scaled.</src> This calculated value is set as a meta value, which is averaged and put in the database in the future.