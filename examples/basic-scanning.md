---
layout: newocr
title: Basic Scanning
parent: Examples
description: A basic example of how to scan images with NewOCR.
nav_order: 2
permalink: /examples/basic-scanning
github-path: examples/basic-scanning.md
---

# Basic Scanning

After training a font with NewOCR, it is ready to scan an image. For this example, the image being scanned is the following:

{% include image-download.html content="/images/basic-scanning.png" %}

Similar to training, the first thing that needs to be done is is creating some managers. The following creates these objects with the local HSQLDB database stored in `database\ocr_basictraining`

```java
var databaseManager = new OCRDatabaseManager(new File("database\\ocr_basictraining"));
var similarityManager = new DefaultSimilarityManager();
var mergenceManager = new DefaultMergenceManager(databaseManager, similarityManager);
```

Next, it's often helpful to add a check if the database has been trained or not, or else an error will be thrown. This can be done by the [OCRDatabaseManager#isTrainedSync()](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/database/OCRDatabaseManager.html#isTrainedSync()) method.

```java
if (!databaseManager.isTrainedSync()) {
    System.err.println("The database has not been trained yet! Please run com.uddernetworks.newocr.demo.TrainDemo to train it and try again.");
    databaseManager.shutdown(TimeUnit.SECONDS, 1L);
    return;
}
```

Also similar to training, next that is needed is the font configuration manager. This is to read the correct configuration for the font that has been set, Comic Sans. This path is to a predefined file in the NewOCR library. This also applied the configuration values to the SimilarityManager and MergenceManager created prior.

```java
var fontConfiguration = new HOCONFontConfiguration("fonts/ComicSans", new ConfigReflectionCacher(), similarityManager, mergenceManager);
```

After this, this object to scan the image must be created, using the fetched configuration options.

```java
var ocrScan = new OCRScan(databaseManager, fontConfiguration.fetchOptions(), similarityManager);
```

Once that object has been created, the OCR is ready to scan the image, in this case, `"basic-scanning.png"`. The method [OCRScan#scanImage(File)](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/recognition/OCRScan.html#scanImage(java.io.File)) simply returns a [ScannedImage](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/ScannedImage.html) which contains all image data.

```java
ScannedImage scannedImage = ocrScan.scanImage(new File("basic-scanning.png"));
```

The image has already been scanned, though to get a clean output the following can be done:

```java
System.out.println(scannedImage.getPrettyString());
```

Sometimes an image will contain an excessive amount of spaces in the beginning of it due to text and image margins. To do this, the [OCRUtils#removeLeadingSpaces(String)](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/utils/OCRUtils.html#removeLeadingSpaces(java.lang.String)) can be used.

```java
System.out.println(OCRUtils.removeLeadingSpaces(scannedImage.getPrettyString()));
```

Shutting down the database can be done right after the scanning, but is usually placed at the end of a program incase the database needs to be reused.

```java
databaseManager.shutdown();
```



The full code in a simple main method can be found on GitHub at [https://github.com/MSPaintIDE/NewOCR/.../examples/basicscanning/Scanning.java](https://github.com/MSPaintIDE/NewOCR/tree/master/demo/src/main/java/examples/basicscanning/Scanning.java)

```java
public class Scanning {
    public static void main(String[] args) throws IOException {
        var databaseManager = new OCRDatabaseManager(new File("database\\ocr_basictraining"));
        var similarityManager = new DefaultSimilarityManager();
        var mergenceManager = new DefaultMergenceManager(databaseManager, similarityManager);

        if (!databaseManager.isTrainedSync()) {
            System.err.println("The database has not been trained yet! Please run com.uddernetworks.newocr.demo.TrainDemo to train it and try again.");
            databaseManager.shutdown(TimeUnit.SECONDS, 1L);
            return;
        }

        var fontConfiguration = new HOCONFontConfiguration("fonts/ComicSans", new ConfigReflectionCacher(), similarityManager, mergenceManager);
        var ocrScan = new OCRScan(databaseManager, fontConfiguration.fetchOptions(), similarityManager);

        ScannedImage scannedImage = ocrScan.scanImage(new File("basic-scanning.png"));
        System.out.println(OCRUtils.removeLeadingSpaces(scannedImage.getPrettyString()));
        
        databaseManager.shutdown();
    }
}
```

