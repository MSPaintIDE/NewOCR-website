---
layout: newocr
title: Training Image
description: How the training image is generated in NewOCR.
parent: Training
grand_parent: Explanation
nav_order: 1
permalink: /explanation/training/image
github-path: explanation/training/image.md
---

# Training Image

The training image generation is the precursor to training. It creates an image in a specific format in an arbitrary font to allow it to read and collect data without specifying an individually labeled character image.

## Generation

The training image relies on a few options that can be set in the code. There is the minimum font size, maximum font size, and font family. The minimum/maximum font size are the font sizes (In points) that the OCR will train on. By default these values are 30 and 90 respectively, as adding more won't help much in most fonts. The font family is the font family to generate the image on.

To generate the image, the system goes from the maximum font at the top of the image, down to the minimum font printing the text below on each line in the decrementing font size. Due to the font string being hardcoded into the OCR, it can not currently be changed, though there is [an open issue](https://github.com/RubbaBoy/NewOCR/issues/9) to add arbitrary alphabet support. This is the training string used:

```
!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~W W
```

## Special Formatting Cases

The training string is meant to provide the most common ASCII characters that may be tested for, though there is an anomaly that one may notice at the end. The two `W`'s separated by a space are meant to give an estimate of the average spacing between characters. During training, when it hits the second `W` in the string, it keeps track of the farthest right X coordinate. Then when it hits the last `W`, it subtracts the beginning of that character with the stored X value to get the space width.