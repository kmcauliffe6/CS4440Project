//
//  File.swift
//  CS4440
//
//  Created by Jahin Ahmed on 4/22/20.
//  Copyright © 2020 Georgia Teach. All rights reserved.
//

import Foundation
import RealmSwift

class Sentiment: Object {
    //Define data here
    @objc dynamic var name: String = ""
    @objc dynamic var sentiment: String = ""
    @objc dynamic var sentimentScore: Int = 0
    @objc dynamic var numNegative: Int = 0
    @objc dynamic var numNeutral: Int = 0
    @objc dynamic var numPositive: Int = 0
    @objc dynamic var timestamp: String = ""

    //dynamic var time TYPE
}
