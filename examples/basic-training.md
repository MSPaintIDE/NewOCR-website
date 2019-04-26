---
layout: newocr
title: Basic Training
parent: Examples
description: A basic example of how to train NewOCR.
nav_order: 1
permalink: /examples/basic-training
github-path: examples/basic-training.md
---

# Basic Training

Before anything can be done with NewOCR, it needs to be trained. This comes in two steps, the first being generating the training image, the second being actually training it.

## Generating The Training Image

To generate a very basic training image, the only thing that needs to be done is use the method [ComputerTrainGenerator#generateTrainingImage(File, TrainGeneratorOptions)](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/train/ComputerTrainGenerator.html#generateTrainingImage(java.io.File,com.uddernetworks.newocr.train.TrainGeneratorOptions)) In this example, the font being used is Comic Sans, with default options other than that. This method can be used to generate the train image `train_comicsans.png` like the following:

```java
new ComputerTrainGenerator().generateTrainingImage(new File("train_comicsans.png"),
        new TrainGeneratorOptions().setFontFamily("Comic Sans MS"));
```

## Training With The Image

After the training image has been generated, it can be trained. First, some managers must be created. More specifically, the DatabaseManager, SimilarityManager, and MergenceManager. The following creates these objects with the local HSQLDB database stored in `database\ocr_basictraining`

```java
var databaseManager = new OCRDatabaseManager(new File("database\\ocr_basictraining"));
var similarityManager = new DefaultSimilarityManager();
var mergenceManager = new DefaultMergenceManager(databaseManager, similarityManager);
```

Next, the font configuration manager must be created. This is to read the correct configuration for the font that has been set, Comic Sans. This path is to a predefined file in the NewOCR library. This also applied the configuration values to the SimilarityManager and MergenceManager created prior.

```java
var fontConfiguration = new HOCONFontConfiguration("fonts/ComicSans", new ConfigReflectionCacher(), similarityManager, mergenceManager);
```

After this, the object to actually train the database must be created using the options from the configuration file, which can be done simply by:

```java
var ocrTrain = new OCRTrain(databaseManager, fontConfiguration.fetchOptions());
```

After that has been created, the database can be trained with the [OCRTrain#trainImage(File)](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/recognition/OCRTrain.html#trainImage(java.io.File)) method, with the argument pointed towards the generated image in the first step.

```java
ocrTrain.trainImage(new File("train_comicsans.png"));
```

After this completes, the database will be fully trained. It next needs to be shut down, which should be after around 1 second of delay to let things fully propagate in the HSQLDB database. This will be using the method [DatabaseManager#shutdown(TimeUnit, long)](https://docs.newocr.dev/NewOCR/com/uddernetworks/newocr/database/DatabaseManager.html#shutdown(java.util.concurrent.TimeUnit,long)). Note this _does_ use Thread.sleep on the thread this method is invoked on, so the delay may need to be manual depending on the application this is being used in.

```java
databaseManager.shutdown(TimeUnit.SECONDS, 1L);
```

The full code in a simple main method can be found on GitHub at [https://github.com/MSPaintIDE/NewOCR/.../examples/basictraining/Training.java](https://github.com/MSPaintIDE/NewOCR/tree/master/demo/src/main/java/examples/basictraining/Training.java)

```java
public class Training {
    public static void main(String[] args) throws IOException {
        new ComputerTrainGenerator().generateTrainingImage(new File("train_comicsans.png"),
                new TrainGeneratorOptions().setFontFamily("Comic Sans MS"));

        var databaseManager = new OCRDatabaseManager(new File("database\\ocr_basictraining"));
        var similarityManager = new DefaultSimilarityManager();
        var mergenceManager = new DefaultMergenceManager(databaseManager, similarityManager);

        var fontConfiguration = new HOCONFontConfiguration("fonts/ComicSans", new ConfigReflectionCacher(), similarityManager, mergenceManager);

        var ocrTrain = new OCRTrain(databaseManager, fontConfiguration.fetchOptions());

        ocrTrain.trainImage(new File("train_comicsans.png"));

        databaseManager.shutdown(TimeUnit.SECONDS, 1L);
    }
}
```

