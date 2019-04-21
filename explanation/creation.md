---
layout: newocr
title: Creation
parent: Explanation
description: The reasoning behind creating the OCR, and what it is meant to do/not meant to do.
nav_order: 1
permalink: /explanation/creation
github-path: explanation/creation.md
---

# Creation

## Background/Motive

The original motive of NewOCR was to create a library to read text from the project [MS Paint IDE](https://ms-paint-i.de/). It originally tailored towards its needs, but quickly grew from that. After a lot of research on past OCRs, better techniques were implemented and the codebase grew into the more professional quality it is currently in, not tailored towards usage in any other project.

## What it is

NewOCR *is* a library to train a database with minimal data on a font, and then be able to accurately recognize characters from input character images. It is meant to work for a variety of computer-generated fonts, and is easy to add more fonts that follow the font requirements.

## What it isn't

NewOCR is *not* an OCR that reads natural images (Non computer-generated images). It is not meant to read images with excessive noise either, or skew/rotation to the text. The OCR is also not meant to incorporate machine learning/neural networks, which makes modifying it easy and expandable, without making things confusing for users who are not interested in learning how neural networks work. NewOCR isn't meant to use excessive libraries for text detection, as it is meant to be a full implementation/example of an OCR.

## Research

A lot of research has gone into the development of NewOCR. There are a lot of good research papers on OCR technologies, with various different implementations, and varying levels of success.Some of the following research papers weren't used in the final release of NewOCR, but were used in the development and testing of the OCR, or are just good resources on making your own similar OCR.

The following research papers were used:

- https://www.researchgate.net/publication/260405352_OPTICAL_CHARACTER_RECOGNITION_OCR_SYSTEM_FOR_MULTIFONT_ENGLISH_TEXTS_USING_DCT_WAVELET_TRANSFORM
- https://core.ac.uk/download/pdf/20643247.pdf
- https://www.researchgate.net/publication/321761298_Generalized_Haar-like_filters_for_document_analysis_application_to_word_spotting_and_text_extraction_from_comics
- https://pdfs.semanticscholar.org/c8b7/804abc030ee93eff2f5baa306b8b95361c57.pdf
- http://www.frc.ri.cmu.edu/~akeipour/downloads/Conferences/ICIT13.pdf
- https://support.dce.felk.cvut.cz/mediawiki/images/2/24/Bp_2017_troller_milan.pdf
- http://www.cs.toronto.edu/~scottl/research/msc_thesis.pdf
- https://www.researchgate.net/publication/258651794_Novel_Approach_for_Baseline_Detection_and_Text_Line_Segmentation
- https://www.researchgate.net/publication/2954700_Neural_and_fuzzy_methods_in_handwriting_recognition
- https://cyber.felk.cvut.cz/theses/papers/444.pdf

# Process

The way the OCR goes from reading the image to returning text can be broken down into a few steps, broken into the training and scanning category. Training reads the characters and puts data into a database, and scanning uses the trained data to get the characters.

## Training



## Scanning