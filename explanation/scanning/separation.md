---
layout: newocr
title: Separation
description: How character separation works during scanning in NewOCR.
parent: Scanning
grand_parent: Explanation
nav_order: 1
permalink: /explanation/scanning/separation
github-path: explanation/scanning/separation.md
---

# Character Separation

Character separation is a simple process in scanning an image in NewOCR. Since each piece of a character (The dot of an I, the top part of an equals sign, the two separate circles of a percent, etc.) are defined as completely separate characters, no character merging is required yet.

<src data-gh="https://github.com/RubbaBoy/NewOCR/blob/795bb0cdc88e44478778ce15e3b0db39e21a86d7/src/main/java/com/uddernetworks/newocr/recognition/OCRActions.java#L55-L67">The first thing the OCR does it go through all black pixels of the input image (after image binarization), and for every black pixel it gets, it gets all touching pixels recursively.</src>
