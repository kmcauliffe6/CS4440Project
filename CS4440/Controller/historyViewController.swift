//
//  historyViewController.swift
//  CS4440
//
//  Created by yassine attia on 4/23/20.
//  Copyright © 2020 Georgia Teach. All rights reserved.
//

import UIKit
import RealmSwift
import SwifteriOS
import SwiftyJSON

class historyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var sents: Results<Sentiment>!
    var arrOfSents :[String] = []
    var comName :[String] = []
    var comSentiment :[String] = []
    //var arrOfSentsLabel: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    let swifter = Swifter(consumerKey: "UhIGvRC8EL7QDo0aXs2Hwjv0B", consumerSecret: "5Qv87L0V2FtLR8tKkj02mf7hwY5mMUkKB8qTCF5oDpHoNJ7KRK")
    
    let classifier = TwitterSentimentClassifer()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // here we specify how many rows the table view will have
        load()
        return arrOfSents.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Here we configuere the cells that appears in the Table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! sentTableViewCell
        cell.textLabel?.text = arrOfSents[indexPath.row] 
        //cell.sentiment.text = "Sentiment: \(arrOfSents[indexPath.row]["sentiment"] as! String)"
        // We will add the time when we implement it
        //we will add a feature so when we click on a company name all its history appears
        cell.sentiment.text = "" // for now we can put anything here after probably average score
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Specify the size of the individuals cell in the table view
          return 100
      }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // what happens when you click on a cell
        //self.performSegue(withIdentifier: "seeCompanyDetails", sender: self)
       }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // need this for the next storyboard, it helps pass data from one to another
        if segue.identifier == "seeCompanyDetails"{
            print("preparing test")

            let destination = segue.destination as! historyDetailsViewController
            //destination.textField.text = "testing"
            print(sender)
            
        }
    }

    
    func load() {
        let realm = try! Realm()
        sents = realm.objects(Sentiment.self)
        var message = ""
        for s in sents {
            if(!arrOfSents.contains(s["name"] as! String)) {
                //comName.append(s["name"] as! String)
                arrOfSents.append(s["name"] as! String)
                swifter.searchTweet(using: s["name"] as! String, lang: "en", count: 100, tweetMode: TweetMode.extended, success: { (results, searchMetadata) in
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
                     for p in predictions {
                         let sent = p.label
                         //print(sent)
                         if sent == "Pos" {
                              sScore = sScore + 1
                         }
                         else if sent == "Neg" {
                             sScore = sScore - 1
                         }
                     }
                    if sScore > 3 {
                         message = "Positive"
                     } else if sScore < -3 {
                         message = "Negative"
                     } else {
                        message = "Neutral"
                     }
                    self.comSentiment.append(message)
                    
                    } catch {
                        print("Error classifying tweets")
                    }
                    }) { (err) in
                        print("Error occured connecting to Twitter API")
                }
                
            }
        }
        let x = comName.count - 1
        print(comName.count)
        print(self.comSentiment)
        

//        for i in 0..<x {
//            var out = ("\(comName[i])...\(comSentiment[i]) a few seconds ago...")
//            arrOfSents.append(out)
//        }
            
    
    }
 
}
