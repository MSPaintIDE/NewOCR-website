---
layout: newocr
title: Font Detection
parent: Examples
description: An example of getting the font size of text using NewOCR.
keywords: Font, Detection, Size
nav_order: 3
permalink: /examples/font-detection
github-path: examples/font-detection.md
---

# Font Detection

After training a font with NewOCR, the image's font can be detected. For this example, the image being scanned is the following, written in 20pt (27px) font:

{% include image-download.html path="/images/basic_scan.png" name="basic-scanning.png" %}

This will be using similar code to the basic training and scanning, the only difference being the definition of [OCRActions](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/recognition/OCRActions.html) which provides the method being used to detect font sizes in the future.

```java
var databaseManager = new OCRDatabaseManager(new File("database\\ocr_basictraining"));
var similarityManager = new DefaultSimilarityManager();
var mergenceManager = new DefaultMergenceManager(databaseManager, similarityManager);

var fontConfiguration = new HOCONFontConfiguration("fonts/ComicSans", new ConfigReflectionCacher(), similarityManager, mergenceManager);

var actions = new OCRActions(databaseManager, fontConfiguration.fetchOptions());

var ocrScan = new OCRScan(databaseManager, similarityManager, mergenceManager, actions);
ScannedImage scannedImage = ocrScan.scanImage(new File("basic-scanning.png"));
```

Next, the method [ScannedImage#stripLeadingSpaces()](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/recognition/ScannedImage.html#stripLeadingSpaces()) will be used to remove any common leading spaces. This does the same thing as the [OCRUtils#removeLeadingSpaces(String)](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/utils/OCRUtils.html#removeLeadingSpaces(java.lang.String)) method used in the [basic scanning example](/examples/basic-scanning), but modifies the [ImageLetter](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/character/ImageLetter.html) object so the first character will be a non-space.

```java
System.out.println(scannedImage.stripLeadingSpaces().getPrettyString());
```

Next, the first character needs to be fetched. In a real-life application this should check to ensure the character is present, though for sake of simplicity this is not included in this example.

```java
var first = scannedImage.letterAt(0).get();

System.out.println("\nFirst letter is " + first);
```

To get the actual font size in pixels only uses one method, which is [Actions#getFontSize(ImageLetter)](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/recognition/Actions.html#getFontSize(com.uddernetworks.newocr.character.ImageLetter)).

```java
var size = (int) actions.getFontSize(first).orElse(0);
```

This can be printed out, and for sake of example this will give both the font size in pixels and in points (Using the [ConversionUtils](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/utils/ConversionUtils.html) class)

```java
System.out.println("Estimated font size is " + ConversionUtils.pixelToPoint(size) + "pt or " + size + "px");
```

As like with normal scanning, shutting down the database can be done right after the scanning, but is usually placed at the end of a program incase the database needs to be reused.

```java
databaseManager.shutdown();
```



The full code in a simple main method can be found on GitHub at [https://github.com/MSPaintIDE/NewOCR/.../examples/fontdetection/FontDetection.java](https://github.com/MSPaintIDE/NewOCR/blob/master/demo/src/main/java/examples/fontdetection/FontDetection.java)

```java
public class FontDetection {
    public static void main(String[] args) throws IOException {
        var databaseManager = new OCRDatabaseManager(new File("database\\ocr_basictraining"));
        var similarityManager = new DefaultSimilarityManager();
        var mergenceManager = new DefaultMergenceManager(databaseManager, similarityManager);

        var fontConfiguration = new HOCONFontConfiguration("fonts/ComicSans", new ConfigReflectionCacher(), similarityManager, mergenceManager);

        var actions = new OCRActions(databaseManager, fontConfiguration.fetchOptions());

        var ocrScan = new OCRScan(databaseManager, similarityManager, mergenceManager, actions);

        ScannedImage scannedImage = ocrScan.scanImage(new File("basic-scanning.png"));
        System.out.println(scannedImage.stripLeadingSpaces().getPrettyString());

        var first = scannedImage.letterAt(0).get();

        System.out.println("\nFirst letter is " + first);

        var size = (int) actions.getFontSize(first).orElse(0);

        System.out.println("Estimated font size is " + ConversionUtils.pixelToPoint(size) + "pt or " + size + "px");

        databaseManager.shutdown();
    }
}
```

