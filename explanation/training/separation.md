---
layout: newocr
title: Separation
description: How character separation works during training in NewOCR.
parent: Training
grand_parent: Explanation
nav_order: 1
permalink: /explanation/training/separation
---

# Character Separation

Character separation is the very first step in how the OCR, where a similar process occurs during scanning. character separation allows each character to be broken into a separate group to perform future data calculation on.

## Line Separation

Before characters are separated, a process unique to training occurs, called line separation. This detects any horizontal breaks in each row, to find each line of characters from the training image. Sometimes characters such as the dot of an `i` or a `_` will be above or below all other characters, and will result in a separate line. This is overcome by the `OCROptions#setMaxPercentDiffToMerge(double)` method (// TODO: link) which sets a percentage of the main line's height in pixels another line must be away for it to merge, since it is most likely part of the same line. This can only be done during training, as there is a known consistent format of characters/lines.

## Character Separation

After each line is separated, the characters can be extracted. From a line, all touching black pixels are grouped together, and all vertically overlapping groups are grouped together in a list for each overlapping group. Each list is then ordered by Y value, and iterated through where each part is given an incrementing *modifier*, which is the same for every part of a character. It is also given the character from the known string in the training file.

If any characters require distance checks, such as the distance between a dot of a character and its base, the space between an `=`, `:`, etc. then it is calculated by the distance of the part and the base, divided by the height of the base. This allows for the distance to be highly scalable, as fonts' spacing ratios don't change when scaled. This calculated value is set as a meta value, which is averaged and put in the database in the future.