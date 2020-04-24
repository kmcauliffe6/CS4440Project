import Cocoa
import CreateML

// pull Twitter data from CSV file
let twitterData = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/jahinjin/spring20/CS4440Project/full-corpus.csv"))

// split data into testing and training data
let(trainingData, testingData) = twitterData.randomSplit(by: 0.80, seed: 3)

//run MLTextClassifier on the training data
let classifier = try MLTextClassifier(trainingData: trainingData, textColumn: "TweetText", labelColumn: "Sentiment")

// measure the accuracy of the model
let metrics = classifier.evaluation(on: testingData, textColumn: "TweetText", labelColumn: "Sentiment")
let accuracy = (1.0 - metrics.classificationError) * 100

let metadata = MLModelMetadata(author: "Paige McAuliffe", shortDescription: "ML Model for CS4440 project for classifying tweets", version: "1.0")

// save ML model for later
try classifier.write(to: URL(fileURLWithPath: "/Users/jahinjin/spring20/CS4440Project/TwitterSentimentClassifer.mlmodel"))

