---
layout: newocr
title: Separation
description: How character separation works during training in NewOCR.
parent: Training
grand_parent: Explanation
nav_order: 2
permalink: /explanation/training/separation
github-path: explanation/training/separation.md
---

# Character Separation

Character separation is the very first step in how the OCR works, where a similar process occurs during scanning. character separation allows each character to be broken into a separate group to perform future data calculation on.

Please note that <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/e11843c16032338e58ec98839d009505f39b449c/src/main/java/com/uddernetworks/newocr/recognition/OCRTrain.java#L58">this process does happen after binarization of the image,</src> where in many OCRs would be paired with other preprocessing (Usually for dealing with natural images, which NewOCR does not support).

## Line Separation

Before characters are separated, a process unique to training occurs, called line separation. <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/795bb0cdc88e44478778ce15e3b0db39e21a86d7/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L297-L338">This detects any horizontal breaks in each row, to find each line of characters from the training image.</src> <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/795bb0cdc88e44478778ce15e3b0db39e21a86d7/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L342-L360">Sometimes characters such as the dot of an <code>i</code> or a <code>_</code> will be above or below all other characters, and will result in a separate line. This is overcome by the <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/e11843c16032338e58ec98839d009505f39b449c/src/main/java/com/uddernetworks/newocr/train/OCROptions.java#L72"><code>OCROptions#setMaxPercentDiffToMerge(double)</code></src> method which sets a percentage of the main line's height in pixels another line must be away for it to merge, since it is most likely part of the same line.</src> This can only be done during training, as there is a known consistent format of characters/lines.

## Character Separation

After each line is separated, the characters can be extracted. <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/795bb0cdc88e44478778ce15e3b0db39e21a86d7/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L102-L114">From a line, all touching black pixels are grouped together, and all vertically overlapping groups are grouped together in a list for each overlapping group.</src> <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/795bb0cdc88e44478778ce15e3b0db39e21a86d7/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L124-L171">Each list is then ordered by Y value, and iterated through where each part is given an incrementing *modifier*, which is the same for every part of a character. It is also given the character from the known string in the training file later on.</src>

<src data-gh="https://github.com/RubbaBoy/NewOCR/blob/795bb0cdc88e44478778ce15e3b0db39e21a86d7/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L153-L165">If any characters require distance checks, such as the distance between a dot of a character and its base, the space between an <code>=</code>, <code>:</code>, etc. then it is calculated by the distance of the part and the base, divided by the height of the base. This allows for the distance to be highly scalable, as fonts' spacing ratios don't change when scaled.</src> This calculated value is set as a meta value, which is averaged and put in the database in the future.