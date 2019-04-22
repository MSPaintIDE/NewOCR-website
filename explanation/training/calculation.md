---
layout: newocr
title: Calculation
description: How character separation works during training in NewOCR.
parent: Training
grand_parent: Explanation
nav_order: 3
permalink: /explanation/training/calculation
github-path: explanation/training/calculation.md
---

# Character Calculation

Arguably the most important step in the OCR, the system next needs to derive the data it's going to store in the database.

## Character Segmentation

First, the character is broken up into 16 pieces, These pieces are not pixel based, but percentage based to keep it scalable among multiple font sizes, as fonts carry the same proportions when scaling up/down.

<src data-gh="https://github.com/RubbaBoy/NewOCR/blob/e11843c16032338e58ec98839d009505f39b449c/src/main/java/com/uddernetworks/newocr/character/SearchCharacter.java#L80-82">First, the letter is horizontally broken up into top and bottom sections. Then, each of those two sections are broken up vertically into another two sections. The remaining sections are broken up into diagonal sections, with their diagonals angling towards the center of the character.</src> A visual of what the sections look like and their index of the value array (Which will be used later) can be found here:

![](/images/E1.png)

After that process has occurred, the second sectioning process starts. This one is more simple, in that <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/e11843c16032338e58ec98839d009505f39b449c/src/main/java/com/uddernetworks/newocr/character/SearchCharacter.java#L84-85">it first horizontally separates it into thirds, then those sections into vertical thirds.</src> The sections and their indices look like the following:

![](/images/E2.png)

## Applying The Sections

After the sections and their indices have been established, <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/e11843c16032338e58ec98839d009505f39b449c/src/main/java/com/uddernetworks/newocr/character/SearchCharacter.java#L93-102">the OCR gets the percentage the pixels are black (Rather than white, as it's effectively binary image).</src> Applied to the generated sections, this is what the values for sections of the letter **E** would look like (Depending on the size, these values may vary):

![](/images/Eval1.png)

![](/images/Eval2.png)

With the indices applied, the value array would be:

```
[0.86, 0.51, 0.46, 0.48, 0.46, 0.67, 0.43, 0.09, 0.77, 0.37, 0.37, 0.77, 0.36, 0.36, 0.77, 0.37, 0.37]
```

## Storing The Data

After the data is calculated for each character, <src data-gh="https://github.com/RubbaBoy/NewOCR/blob/e11843c16032338e58ec98839d009505f39b449c/src/main/java/com/uddernetworks/newocr/recognition/OCRTrain.java#L197-L202">the 16 data points are separately averaged with all other characters, and then the resulting points are stored in the database.</src>

