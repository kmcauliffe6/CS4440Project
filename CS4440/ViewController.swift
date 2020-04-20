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

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    // Instantiation using Twitter's OAuth Consumer Key and secret
   let swifter = Swifter(consumerKey: "API KEY", consumerSecret: "API SECRET")
    
    let classifier = TwitterSentimentClassifer()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
            swifter.searchTweet(using: "Facebook", lang: "en", count: 50, tweetMode: TweetMode.extended, success: { (results, searchMetadata) in
                // 'full_text' field of JSON holds the tweet message
                
            var tweets = [TwitterSentimentClassiferInput]()
                
            //get 50 tweets about the input text
            for x in 0..<50 {
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
                    if sent == "Pos" {
                         sScore += 1
                    }
                    else if sent == "Neg" {
                        sScore -= 1
                    }
                }
                if sScore > 10 {
                    self.sentimentLabel.text = "Twitter users regard this company positively! This stock is a good choice."
                } else if sScore < -10 {
                    self.sentimentLabel.text = "Twitter users do not like this company today. Invest at your own risk :("
                } else {
                    self.sentimentLabel.text = "Twitter users are feeling neutral about this company."
                }
                    
            } catch {
                print("Error classifying tweets")
            }
        }) { (err) in
            print("Error occured connecting to Twitter API")
        }
    }
    
    }
    
}
