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

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UITextView!
    @IBOutlet weak var predictB: UIButton!
    
    // Instantiation using Twitter's OAuth Consumer Key and secret
   let swifter = Swifter(consumerKey: "UhIGvRC8EL7QDo0aXs2Hwjv0B", consumerSecret: "5Qv87L0V2FtLR8tKkj02mf7hwY5mMUkKB8qTCF5oDpHoNJ7KRK")
    
    let classifier = TwitterSentimentClassifer()
    let realm = try! Realm()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        predictB.layer.cornerRadius = 10
        predictB.clipsToBounds = true
        load()
        
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
    
    func load() {
        let realm = try! Realm()
        var sents: Results<Sentiment> = realm.objects(Sentiment.self)
        var set:
        print("type : \(type(of: sents))")
        for c in sents {
            // print(type(of: c["name"]!))
//            if arr.contains(c["name"]!) {
//                 arr.append(c["name"]!)
            }
        print(Set(sents))
    }

    @IBAction func predictPressed(_ sender: Any) {
        // checking text field is not empty
        if let userInput = textField.text {
            
            // using Twitter Standard Search API
            //https://developer.twitter.com/en/docs/tweets/search/overview/standard
            //return a collection of relevant tweets based on a query
            swifter.searchTweet(using: userInput, lang: "en", count: 100, tweetMode: TweetMode.extended, success: { (results, searchMetadata) in
                // 'full_text' field of JSON holds the tweet message
                
            var tweets = [TwitterSentimentClassiferInput]()
                
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
                     self.sentimentLabel.text = "great choice! very popular right now"
                     message = "Positive"
                 } else if sScore > 3 {
                     self.sentimentLabel.text = "good but not great"
                     message = "Positive"
                 } else if sScore < -5 {
                     self.sentimentLabel.text = "awful choice."
                     message = "Negative"
                 } else if sScore < -3 {
                     self.sentimentLabel.text = "not too bad"
                     message = "Negative"
                 } else {
                     self.sentimentLabel.text = "this one is okay"
                     message = "Neutral"
                 }
                 let newSentiment = Sentiment()
                 newSentiment.name = userInput
                 newSentiment.sentiment = message
                 newSentiment.sentimentScore = sScore
                 newSentiment.numNegative = negCount
                 newSentiment.numNeutral = neutral
                 newSentiment.numPositive = posCount
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
