//
//  historyDetailsViewController.swift
//  CS4440
//
//  Created by Paige McAuliffe on 4/23/20.
//  Copyright © 2020 Georgia Teach. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Charts



extension Collection where Iterator.Element == Int {
    var doubleArray: [Double] {
        return compactMap{ Double($0) }
    }
    var floatArray: [Float] {
        return compactMap{ Float($0) }
    }
}



class historyDetailsViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var Label: UILabel!
    
    var sents: Results<Sentiment>!
    var arrOfsScore :[Int] = []
    var arrOftimestamp :[String] = []
    var dataEntries:[ChartDataEntry] = []
    var compname = ""
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = "\(compname)'s History"
        //print(compname)
        
        axisFormatDelegate = self
        let realm = try! Realm()
        self.sents = realm.objects(Sentiment.self)
        //sents = sents.filter("name CONTAINS[cd] %@", "Apple") as! Results<Sentiment>
        for s in sents {
            if (s["name"] as! String) == compname {
                self.arrOfsScore.append(s["sentimentScore"] as! Int)
                self.arrOftimestamp.append(s["timestamp"] as! String)
            }
        }
        let doublesScore = arrOfsScore.doubleArray
        //print(doublesScore)
        print(arrOftimestamp)
        
        setChart(dataEntryX: arrOftimestamp, dataEntryY: doublesScore)

    }

    func setChart(dataEntryX forX: [String], dataEntryY forY: [Double]) {
        //viewForChart.noDataText = "No data inputted yet"
        var dataEntries: [ChartDataEntry] = []

        for i in 0..<forX.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: forY[i])
            print(dataEntry)
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Sentiment Score")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.backgroundColor = UIColor(red: 250/255, green:250/255, blue: 250/255, alpha: 1)
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        let xAxisValue = lineChartView.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
        
        //xAxisValue.valueFormatter = axisFormateDelegate
    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //TODO make funciton to get the name selected from previous screen
    //i.e. company = company?.
    
    
}
extension historyDetailsViewController: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return arrOftimestamp[Int(value)]
    }
}

