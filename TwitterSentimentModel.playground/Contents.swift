import Cocoa
import CreateML

// pull Twitter data from CSV file
let twitterData = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/paigemca/CS4440/twitter-sanders-apple3.csv"))

// split data into testing and training data
let(trainingData, testingData) = twitterData.randomSplit(by: 0.80, seed: 3)

//run MLTextClassifier on the training data
let classifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

// measure the accuracy of the model
let metrics = classifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")
let accuracy = (1.0 - metrics.classificationError) * 100

let metadata = MLModelMetadata(author: "Paige McAuliffe", shortDescription: "ML Model for CS4440 project for classifying tweets", version: "1.0")

// save ML model for later
try classifier.write(to: URL(fileURLWithPath: "/Users/paigemca/CS4440/TwitterSentimentClassifer.mlmodel"))

