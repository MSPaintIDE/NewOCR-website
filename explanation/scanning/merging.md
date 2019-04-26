---
layout: newocr
title: Merging
description: How character mergence works during scanning in NewOCR.
keywords: Character Mergence, Merge, Merge Rule
parent: Scanning
grand_parent: Explanation
nav_order: 3
permalink: /explanation/scanning/merging
github-path: explanation/scanning/merging.md
---

# Character Mergence

After characters are identified, there are still a lot of separated pieces, such as two parts from an `=` or a `:`, or the dots from characters such as `!` or `?`. This is solved with merge rules, which are rules that specify what characters to merge together after everything has been detected.

## Defining Merge Rules

Merge rules are loaded in from <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/resources/fonts/Default.conf#L35-L39">a list in the default configuration file,</src> which are just a conical path to a class extending <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/MergeRule.java">MergeRule.class</src> This class provides the basic methods that the system uses to merge characters. These rules are added in the <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/DefaultMergenceManager.java">DefaultMergenceManager</src> class. These individual rules rely on data collected during training, which are primarily distances character parts are from each other. The distance is divided by the width to make it scalable and averaged during training, so a projected distance can be generated in the rule after being fetched from the database.

Each merge rule can either be horizontal or vertical, <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/DefaultMergenceManager.java#L67-L69">horizontal rules being given a list of characters all in a horizontal line from one another, and vertical rules being given a list of characters overlapping one another vertically.</src>

<src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/DefaultMergenceManager.java#L81-L101">After the rules are processed, individual parts of characters (Things like the top dot of an `i`, a single part of an `"`, a single part of an `=`, etc.) are then defined as their next closest match from recognition. The system then checks to ensure it's not a lone part again, and if not, it continues.</src> The following sections will be short descriptions to show what each default merge rule does.

## ApostropheMergeRule

The <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/ApostropheMergeRule.java">ApostropeMergeRule</src> is meant to merge two vertical lines together to become a `"`.

The rule is horizontal, and firstly <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/ApostropheMergeRule.java#L49-L66">makes sure both inputs are unmerged vertical lines, then making sure their heights are within 25% of each other, so they won't be an apostrophe and a pipe, for instance.</src> <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/ApostropheMergeRule.java#L70-L82">After this, it goes through other characters in the current horizontal line and finds an alphanumeric character and makes sure the size of the apostrophe is no more than 50% of its height, so ensure both vertical lines of the quote don't fill the line, such as two pipes.</src> <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/ApostropheMergeRule.java#L84-L92">Finally, if the distance between the two characters are within the predicted length (From a ratio from training) the characters are merged together and labeled as a quote.</src>

## EqualVerticalMergeRule

The <src data-gh="<https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/EqualVerticalMergeRule.java>">EqualVerticalMergeRule</src> is meant to merge two identical pieces vertically, at the moment being only `:` and `=`.

This is a vertical rule, which first <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/EqualVerticalMergeRule.java#L52-L61">ensures both inputs are unmerged.</src> <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/EqualVerticalMergeRule.java#L68-L87">Then, the estimated vertical distance is set to either the trained distance ratio of an equals sign if both inputs are horizontal lines, or a colon's distance ratio if both are dots. If the characters are both within their distance ratio, they are merged together.</src>

## OverDotMergeRule

The <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/OverDotMergeRule.java">OverDotMergeRule</src> is to merge dots above a character with their lower bases. This includes `i`, `j`, and `;`.

This rule is vertical, and starts off with <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/OverDotMergeRule.java#L54-L86">making sure the base is value and the upper character is a dot, and then sets the correct vertical distance ratio from training according to what the base it.</src> <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/OverDotMergeRule.java#L88-L109">If the difference between the heights and the projected distance from the training ratio is within 50% of the projected value, the characters are merged together and labeled as the correct character.</src>

## PercentMergeRule

The <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/PercentMergeRule.java">PercentMergeRule</src> is simply meant to merge the circles with the forward slash of a percent.

This is a horizontal rule, <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/PercentMergeRule.java#L40-L66">starting off with taking 3 inputs. This rule just ensures 2 of them are empty circles, and the other is a forward slash character. Then, if all are overlapping, it merges them.</src>

## UnderDotMergeRule

The <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/UnderDotMergeRule.java">UnderDotMergeRule</src> is to merge dots below a base character. This includes `?` and `!` currently.

This rule is vertical, and begins with <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/UnderDotMergeRule.java#L54-L68">ensuring the base is valid, the character below is a dot, and neither have been merged in the past.</src> Proceeding this, <src data-gh="https://github.com/MSPaintIDE/NewOCR/blob/7de96263853df8f63d340ecaf26284cb0d4dbb34/src/main/java/com/uddernetworks/newocr/recognition/mergence/rules/UnderDotMergeRule.java#L70-L88">it then gets the correct vertical distance ratio from the base, and merges/labels the characters if the projected distance from the ratio and the actual vertical distance is at least 75% of the projected distance apart.</src>