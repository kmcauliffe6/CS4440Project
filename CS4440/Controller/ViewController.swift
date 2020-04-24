//
//  ViewController.swift
//  CS4440
//
//  Created by Paige McAuliffe on 4/7/20.
//  Copyright © 2020 Georgia Teach. All rights reserved.
//

import UIKit
import SwifteriOS
import SwiftyJSON
import RealmSwift
import Charts

extension String {
    var alphanumeric: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
    
    var letters: String {
        return String(unicodeScalars.filter(CharacterSet.letters.contains))
    }
}

class ViewController: UIViewController {
    

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UITextView!
    @IBOutlet weak var predictB: UIButton!
    @IBOutlet weak var pieChart: PieChartView!
    
    
    // Instantiation using Twitter's OAuth Consumer Key and secret
   let swifter = Swifter(consumerKey: "UhIGvRC8EL7QDo0aXs2Hwjv0B", consumerSecret: "5Qv87L0V2FtLR8tKkj02mf7hwY5mMUkKB8qTCF5oDpHoNJ7KRK")
    
    let classifier = TwitterSentimentClassifer()
    lazy var realm:Realm = {
        return try! Realm()
    } ()
    
    var negData = PieChartDataEntry(value: 0)
    var posData = PieChartDataEntry(value: 0)
    var neuData = PieChartDataEntry(value: 0)
    var total = [PieChartDataEntry]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        predictB.layer.cornerRadius = 10
        predictB.clipsToBounds = true
        
    }
    
    
    func save(sentiment: Sentiment){
        do {
            let realm = try! Realm()
            try realm.write {
                realm.add(sentiment)
            }
        } catch {
            print("Error saving sentiment \(error)")
        }
    }
    func updateChart() {
        pieChart.chartDescription?.text = "Sentiments distribution"
        negData.label = "Number of negative comments"
        posData.label = "Number of positive comments"
        neuData.label = "Number of neutral comments"
        total = [negData, posData, neuData]
        let chartDataSet = PieChartDataSet(entries: total, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor(named: "negColor"), UIColor(rgb: 0x0052a5), UIColor(rgb: 0xc9f0ff)]
        chartDataSet.colors = colors as! [NSUIColor] 
        pieChart.data = chartData
    }


    @IBAction func predictPressed(_ sender: Any) {
        // checking text field is not empty
        if let userInput = textField.text {
            
            // using Twitter Standard Search API
            //https://developer.twitter.com/en/docs/tweets/search/overview/standard
            //return a collection of relevant tweets based on a query
            swifter.searchTweet(using: userInput, lang: "en", count: 1000, tweetMode: TweetMode.extended, success: { (results, searchMetadata) in
                // 'full_text' field of JSON holds the tweet message
                
            var tweets = [TwitterSentimentClassiferInput]()
            var timestmp = ""
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            timestmp = formatter.string(from: currentDateTime)
            //get 1000 tweets about the input text
            for x in 0..<100 {
                if let tweet_msg = results[x]["full_text"].string {
                    tweets.append(.init(text: tweet_msg))
                }
            }
            
                
            // do sentiment analysis on the tweets
            do {
                 let predictions = try self.classifier.predictions(inputs: tweets)
                 // score general sentiment
                 var sScore = 0
                 var posCount = 0
                 var negCount = 0
                 var neutral = 0
                 var message = ""
                 for p in predictions {
                     let sent = p.label
                     //print(sent)
                     if sent == "Pos" {
                          sScore = sScore + 1
                         posCount = posCount + 1
                     }
                     else if sent == "Neg" {
                         sScore = sScore - 1
                         negCount = negCount + 1
                     }
                     else if sent == "Neutral" {
                         neutral = neutral + 1
                     }
                 }
                 if sScore > 5 {
                     self.sentimentLabel.text = "Great choice! very popular right now"
                     message = "Positive"
                 } else if sScore > 3 {
                     self.sentimentLabel.text = "Good but not great"
                     message = "Positive"
                 } else if sScore < -5 {
                     self.sentimentLabel.text = "Awful choice"
                     message = "Negative"
                 } else if sScore < -3 {
                     self.sentimentLabel.text = "Not too bad"
                     message = "Negative"
                 } else {
                     self.sentimentLabel.text = "This one is okay"
                     message = "Neutral"
                 }
                 let newSentiment = Sentiment()
                

                newSentiment.name = userInput.letters.lowercased().capitalized
                 newSentiment.sentiment = message
                 newSentiment.sentimentScore = sScore
                 newSentiment.numNegative = negCount
                 newSentiment.numNeutral = neutral
                 newSentiment.numPositive = posCount
                newSentiment.timestamp = timestmp
                 // updating the pie chart
                self.negData.value = Double(negCount)
                self.posData.value = Double(posCount)
                self.neuData.value = Double(neutral)
                self.updateChart()
                 //TODO tie to variables in tweets
                 self.save(sentiment: newSentiment)
                 print(sScore)
                            } catch {
                print("Error classifying tweets")
            }
        }) { (err) in
            print("Error occured connecting to Twitter API")
        }
    }
    
    }
    
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
