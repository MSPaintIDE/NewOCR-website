---
layout: newocr
title: Calculation
description: How characters are calculated in scanning an image with NewOCR.
parent: Scanning
grand_parent: Explanation
nav_order: 2
permalink: /explanation/scanning/calculation
github-path: explanation/scanning/calculation.md
---

# Character Calculation

During scanning, once the characters are broken into individual objects, they need to be sorted, sectioned, and calculated. This whole process isn't very complex in and of itself.

## Sorting

First, the characters need to be sorted. This is a process unknown to training as the format of the training file insures all characters will be in the same line perfectly. In scanning an image, not all characters will be exactly aligned, so they need to be put in a line. At the beginning of scanning, the lines characters were in were separated, so this step <src data-gh="<https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/OCRScan.java#L131>">just matches the character with the closest line.</src>

## Character Segmentation

{% include calculation.md %}

## Character Matching

After the array of 16 data points are calculated, it's time to <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/OCRScan.java#L133">get the closest character to the current one.</src> <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L192-L201">All data points from all trained characters in the data set are iterated over,</src> and <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/utils/OCRUtils.java#L92-L101">the difference between each respective point of the data array are subtracted and put to the power of two, the sum of all of the points being the difference, 0 being identical.</src>

After these differences are calculated, a closest character still needs to be chosen. If the matching character was chosen just based on these data points, characters being primarily black such as `.`, `,`, `|`, `-`, parts of an `=`, `!`, `?`, and several more would all be detected as each other, as the sizes of these characters have not been taken into account.

With all characters' differences mapped to their database characters being iterated over, the database character's average width is divided by its average height, which then in turn has the input character's width/height value subtracted from it. This value is then multiplied by the size ratio weight from <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/train/OCROptions.java#L89"><code>OCROptions#setSizeRatioWeight(double)</code></src> to allow for some fonts to rely more or less on character width/height ratios. <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L239-L251">The result of this multiplication is added to the character's similarity, and the lowest value from this new calculation will be returned as the closest matching character.</src> <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L256">The remaining list in order from closest-farthest in similarity are attached to the returned character object,</src> to be used in the future.