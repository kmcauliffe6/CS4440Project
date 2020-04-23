//
//  report.swift
//  CS4440
//
//  Created by yassine attia on 4/22/20.
//  Copyright © 2020 Georgia Teach. All rights reserved.
//

import Foundation
import RealmSwift

class report: Object {
    @objc dynamic var score: Int = 0
    @objc dynamic var sentiment: String = ""
    @objc dynamic var negTweets: Int = 0
    @objc dynamic var posTweets: Int = 0
    @objc dynamic var company: String = ""
    @objc dynamic var time: TimeInterval = 0
}
