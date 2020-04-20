//
//  ViewController.swift
//  CS4440
//
//  Created by Paige McAuliffe on 4/7/20.
//  Copyright © 2020 Georgia Teach. All rights reserved.
//

import UIKit
import SwifteriOS
class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    // Instantiation using Twitter's OAuth Consumer Key and secret
    let swifter = Swifter(consumerKey: "API KEY", consumerSecret: "API SECRET")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // using Twitter Standard Search API
        //https://developer.twitter.com/en/docs/tweets/search/overview/standard
        //return a collection of relevant tweets based on a query
        swifter.searchTweet(using: "@Apple", lang: "en", count: 50, tweetMode: TweetMode.extended, success: { (results, searchMetadata) in
            // 'text' field of JSON holds the tweet message
            print(results)
        }) { (err) in
            print("Error occured connecting to Twitter API")
        }
        
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}
