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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        predictB.layer.cornerRadius = 10
        predictB.clipsToBounds = true
        
    
    }

    @IBAction func predictPressed(_ sender: Any) {
        // when text field is not empy
        if let userInput = textField.text {
            //testing classifier
            //let output = try! classifier.prediction(text: "@Amazon is a terrible company")
            //print(output.label) //printing neg!
            
            // using Twitter Standard Search API
            //https://developer.twitter.com/en/docs/tweets/search/overview/standard
            //return a collection of relevant tweets based on a query
            swifter.searchTweet(using: userInput, lang: "en", count: 1000, tweetMode: TweetMode.extended, success: { (results, searchMetadata) in
                // 'full_text' field of JSON holds the tweet message
                
            var tweets = [TwitterSentimentClassiferInput]()
                
            //get 1000 tweets about the input text
            for x in 0..<1000 {
                if let tweet_msg = results[x]["full_text"].string {
                    tweets.append(.init(text: tweet_msg))
                }
            }
            
                
            // do sentiment analysis on the tweets
            do {
                let predictions = try self.classifier.predictions(inputs: tweets)
                // score general sentiment
                var sScore = 0
                for p in predictions {
                    let sent = p.label
                    print(sent)
                    if sent == "Pos" {
                         sScore = sScore + 1
                    }
                    else if sent == "Neg" {
                        sScore = sScore - 1
                    }
                }
                if sScore > 5 {
                    self.sentimentLabel.text = "great choice! very popular right now"
                } else if sScore > 3 {
                    self.sentimentLabel.text = "good but not great"
                } else if sScore < -5 {
                    self.sentimentLabel.text = "awful choice."
                } else if sScore < -3 {
                    self.sentimentLabel.text = "not too bad"
                } else {
                    self.sentimentLabel.text = "this one is okay"
                }
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
