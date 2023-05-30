//
//  FirstViewController.swift
//  Covid19 Info
//
//  Created by Ethan Zemelman on 2020-08-11.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//  API on Github: https://github.com/javieraviles/covidAPI

import UIKit
import Charts

class GlobalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coronaWorldInfo: CoronaInfo?
    let factLabels = ["Total Cases", "Active Cases", "Deaths", "New Deaths", "Recovered", "Critical Cases", "New Cases", ""]
    var facts = [String]()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    var refreshTimer: NSObject?
    
    // For the pie chart
    var activeCasesDataEntry = PieChartDataEntry(value: 0)
    var deathsDataEntry = PieChartDataEntry(value: 0)
    var recoveredDataEntry = PieChartDataEntry(value: 0)
    
    var pieChartDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.refreshControl = refresher
        refresher.layer.zPosition = -1
        
        refreshTimer = Timer.scheduledTimer(timeInterval: 10*60, target: self, selector: #selector(timerRefreshData), userInfo: nil, repeats: true)
        
        requestData()
    }
    
    func setupPieChart(for pieChart: PieChartView) {
        activeCasesDataEntry = PieChartDataEntry(value: Double((coronaWorldInfo?.active)!))
        deathsDataEntry = PieChartDataEntry(value: Double(coronaWorldInfo!.deaths))
        recoveredDataEntry = PieChartDataEntry(value: Double((coronaWorldInfo?.recovered)!))
        
        activeCasesDataEntry.label = "Active Cases"
        deathsDataEntry.label = "Deaths"
        recoveredDataEntry.label = "Recovered"
        
        pieChartDataEntries = [recoveredDataEntry, activeCasesDataEntry, deathsDataEntry]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        pieChart.centerAttributedText = NSAttributedString(
            string: "Outcome Of \nAll Cases",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                NSAttributedString.Key.foregroundColor: UIColor(named: "Tint")!,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
        ])
        
        pieChart.entryLabelColor = .black
        pieChart.usePercentValuesEnabled = true
        pieChart.holeColor = UIColor(named: "Background")!
        pieChart.holeRadiusPercent = 0.4
        pieChart.rotationEnabled = false
        
        let legend = pieChart.legend
        legend.font = .systemFont(ofSize: 17)
        legend.textColor = UIColor(named: "Tint")!
        legend.xEntrySpace = 15
        legend.horizontalAlignment = .center
        
        let chartDataSet = PieChartDataSet(entries: pieChartDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        chartDataSet.valueTextColor = .black
        chartDataSet.valueFont = .systemFont(ofSize: 17)
        chartDataSet.colors = ChartColorTemplates.material()
        
        pieChart.data = chartData
    }
    
    func requestData() {
        getData() { results in
            switch results {
            case .success(let data):
                self.coronaWorldInfo = data[0]
                guard let coronaWorldInfo = self.coronaWorldInfo else { return }
                
                for number in [coronaWorldInfo.cases, coronaWorldInfo.active!, coronaWorldInfo.deaths, coronaWorldInfo.todayDeaths, coronaWorldInfo.recovered!, coronaWorldInfo.critical, coronaWorldInfo.todayCases] {
                    self.facts.append("\(number.withCommas())")
                }
                self.facts.append("")
                
                self.collectionView.reloadData()
            case .failure(let error):
                self.createAlert(title: "No Internet Connection", message: "The content couldn't be loaded. Please check your internet connection and try again.")
                print(error)
            }
        }
    }
    
    @objc func timerRefreshData() {
        getData() { results in
            switch results {
            case .success(let data):
                self.coronaWorldInfo = data[0]
                guard let coronaWorldInfo = self.coronaWorldInfo else { return }
                
                self.facts.removeAll()
                
                for number in [coronaWorldInfo.cases, coronaWorldInfo.active!, coronaWorldInfo.deaths, coronaWorldInfo.todayDeaths, coronaWorldInfo.recovered!, coronaWorldInfo.critical, coronaWorldInfo.todayCases] {
                    self.facts.append("\(number.withCommas())")
                }
                self.facts.append("")
                
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func refresh() {
        getData() { results in
            switch results {
            case .success(let data):
                self.coronaWorldInfo = data[0]
                guard let coronaWorldInfo = self.coronaWorldInfo else { return }
                
                self.facts.removeAll()
                
                for number in [coronaWorldInfo.cases, coronaWorldInfo.active!, coronaWorldInfo.deaths, coronaWorldInfo.todayDeaths, coronaWorldInfo.recovered!, coronaWorldInfo.critical, coronaWorldInfo.todayCases] {
                    self.facts.append("\(number.withCommas())")
                }
                self.facts.append("")

                self.collectionView.reloadData()
                
                // Delay the refreshers loading spinner so it doesn't stop spinning instantly
                let deadline = DispatchTime.now() + .milliseconds(500)
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    self.refresher.endRefreshing()
                }
            case .failure(let error):
                self.createAlert(title: "No Internet Connection", message: "The content couldn't be refreshed. Please check your internet connection and try again.")
                self.refresher.endRefreshing()
                print(error)
            }
        }
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.requestData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Collection View Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        let pieChartCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pieChartCell", for: indexPath) as! PieChartCollectionViewCell
        
        cell.factLabel.text = factLabels[indexPath.row]
        cell.fact.text = facts[indexPath.row]
        
        if indexPath.row == factLabels.count - 1 { setupPieChart(for: pieChartCell.pieChart); return pieChartCell }
        else { return cell }
    }
    
    // Make the last cell's size different
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        
        if UIDevice.current.userInterfaceIdiom == .pad && indexPath.row == factLabels.count - 1 {
            height = 800
        } else if indexPath.row == factLabels.count - 1 { height = 500 }
        else { height = 120 }
        
        width = view.frame.size.width - 35
        
        return CGSize(width: width, height: height)
    }
    
}
