//
//  historyViewController.swift
//  CS4440
//
//  Created by yassine attia on 4/23/20.
//  Copyright © 2020 Georgia Teach. All rights reserved.
//

import UIKit
import RealmSwift

class historyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var sents: Results<Sentiment>!
    var arrOfSents :[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
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
        for s in sents {
            if(!arrOfSents.contains(s["name"] as! String)) {
                arrOfSents.append(s["name"] as! String)
            }
        }
    }
 
}
