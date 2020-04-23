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
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // here we specify how many rows the table view will have
        let realm = try! Realm()
        sents = realm.objects(Sentiment.self)
        return sents?.count ?? 1

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Here we configuere the cells that appears in the Table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! sentTableViewCell
        cell.textLabel?.text = sents[indexPath.row]["name"] as? String
        cell.sentiment.text = "Sentiment: \(sents[indexPath.row]["sentiment"] as! String)"
        // We will add the time when we implement it
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Specify the size of the individuals cell in the table view
          return 100
      }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // what happens when you click on a cell

       }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // need this for the next storyboard, it helps pass data from one to another
    }
 
}
