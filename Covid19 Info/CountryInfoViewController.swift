//
//  SecondViewController.swift
//  Covid19 Info
//
//  Created by Ethan Zemelman on 2020-08-11.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import UIKit
import Charts

class CountryInfoViewController: UIViewController {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var activeCases: UILabel!
    @IBOutlet weak var criticalCases: UILabel!
    @IBOutlet weak var newCases: UILabel!
    @IBOutlet weak var deaths: UILabel!
    @IBOutlet weak var newDeaths: UILabel!
    @IBOutlet weak var recovered: UILabel!
    
    @IBOutlet weak var pieChart: PieChartView!
    var activeCasesDataEntry = PieChartDataEntry(value: 0)
    var deathsDataEntry = PieChartDataEntry(value: 0)
    var recoveredDataEntry = PieChartDataEntry(value: 0)
    
    var pieChartDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the labels with the correct numbers
        countryName.text = "\(filteredCountries[selectedIndex!])"
        totalCases.text = "Total Cases: \(filteredTotalCases[selectedIndex!])"
        activeCases.text = "Active Cases: \(filteredActiveCases[selectedIndex!])"
        criticalCases.text = "Critical Cases: \(filteredCriticalCases[selectedIndex!])"
        newCases.text = "New Cases: \(filteredNewCases[selectedIndex!])"
        deaths.text = "Deaths: \(filteredDeaths[selectedIndex!])"
        newDeaths.text = "New Deaths: \(filteredNewDeaths[selectedIndex!])"
        recovered.text = "Recovered: \(filteredRecovered[selectedIndex!])"
        
        setupPieChart()
    }
    
    func setupPieChart() {
        if dataNotAvailable(filteredActiveCases[selectedIndex!]) || dataNotAvailable(filteredRecovered[selectedIndex!]) {
            pieChart.noDataText = "No chart data available for this country."
            pieChart.noDataFont = .systemFont(ofSize: 20)
            pieChart.noDataTextAlignment = .center
            return
        }
        
        activeCasesDataEntry = PieChartDataEntry(value: filteredActiveCases[selectedIndex!].withoutCommas())
        deathsDataEntry = PieChartDataEntry(value: filteredDeaths[selectedIndex!].withoutCommas())
        recoveredDataEntry = PieChartDataEntry(value: filteredRecovered[selectedIndex!].withoutCommas())
        
        // Percent values
        let total = filteredActiveCases[selectedIndex!].withoutCommas() + filteredDeaths[selectedIndex!].withoutCommas() + filteredRecovered[selectedIndex!].withoutCommas()
        let activeCasesPercentInt = (filteredActiveCases[selectedIndex!].withoutCommas() * 100) / total
        let deathsPercentInt = (filteredDeaths[selectedIndex!].withoutCommas() * 100) / total
        let recoveredPercentInt = (filteredRecovered[selectedIndex!].withoutCommas() * 100) / total
        
        // Format the values with percentages
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        let activeCasesPercent = formatter.string(from: NSNumber(value: activeCasesPercentInt))
        let deathsPercent = formatter.string(from: NSNumber(value: deathsPercentInt))
        let recoveredPercent = formatter.string(from: NSNumber(value: recoveredPercentInt))
         
        activeCasesDataEntry.label = activeCasesPercent
        deathsDataEntry.label = deathsPercent
        recoveredDataEntry.label = recoveredPercent
        
        if (activeCasesPercentInt < 7 && deathsPercentInt < 7) && abs(activeCasesPercentInt - deathsPercentInt) < 4 {
            if deathsPercentInt < activeCasesPercentInt { deathsDataEntry.label = "" }
            else { activeCasesDataEntry.label = "" }
            
        }
        if (deathsPercentInt < 7 && recoveredPercentInt < 7) && abs(deathsPercentInt - recoveredPercentInt) < 4 {
            if deathsPercentInt < recoveredPercentInt { deathsDataEntry.label = "" }
            else { recoveredDataEntry.label = "" }
        }
        if (recoveredPercentInt < 7 && activeCasesPercentInt < 7) && abs(recoveredPercentInt - activeCasesPercentInt) < 4 {
            if activeCasesPercentInt < recoveredPercentInt { recoveredDataEntry.label = "" }
            else { activeCasesDataEntry.label = "" }
        }
        if (activeCasesPercentInt < 10 && deathsPercentInt < 10) && (activeCasesPercentInt <= 1.5 || deathsPercentInt <= 1.5 ) {
            if deathsPercentInt < activeCasesPercentInt { deathsDataEntry.label = "" }
            else { activeCasesDataEntry.label = "" }
        }
        if (deathsPercentInt < 10 && recoveredPercentInt < 10) && (deathsPercentInt <= 1.5 || recoveredPercentInt <= 1.5) {
            if deathsPercentInt < recoveredPercentInt { deathsDataEntry.label = "" }
            else { recoveredDataEntry.label = "" }
        }
        if (recoveredPercentInt < 10 && activeCasesPercentInt < 10) && (recoveredPercentInt <= 1.5 || activeCasesPercentInt <= 1.5) {
            if activeCasesPercentInt < recoveredPercentInt { recoveredDataEntry.label = "" }
            else { activeCasesDataEntry.label = "" }
        }
        
        // Format the text in the hole of the chart
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
        pieChart.entryLabelFont = .systemFont(ofSize: 20)
        pieChart.usePercentValuesEnabled = true
        pieChart.holeColor = UIColor(named: "Background")!
        pieChart.holeRadiusPercent = 0.4
        pieChart.rotationEnabled = false
        
        let activeCasesColor = NSUIColor(red: 219/255, green: 185/255, blue: 65/255, alpha: 1)
        let deathsColor = NSUIColor(red: 214/255, green: 87/255, blue: 69/255, alpha: 1)
        let recoveredColor = NSUIColor(red: 101/255, green: 201/255, blue: 122/255, alpha: 1)
        
        let legend = pieChart.legend
        legend.setCustom(entries: [
            LegendEntry(label: "Active Cases (\(activeCasesPercent!))", form: .square, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: activeCasesColor),
            LegendEntry(label: "Deaths (\(deathsPercent!))", form: .square, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: deathsColor),
            LegendEntry(label: "Recovered (\(recoveredPercent!))", form: .square, formSize: .nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: recoveredColor)
        ])
        legend.xEntrySpace = 15
        legend.horizontalAlignment = .center
        legend.font = .systemFont(ofSize: 17)
        legend.textColor = UIColor(named: "Tint")!
        
        pieChartDataEntries = [recoveredDataEntry, activeCasesDataEntry, deathsDataEntry]
        
        let chartDataSet = PieChartDataSet(entries: pieChartDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
         
        chartDataSet.valueFont = .systemFont(ofSize: 17)
        chartDataSet.valueTextColor = UIColor(named: "Tint")!
        chartDataSet.drawValuesEnabled = false
        chartDataSet.colors = ChartColorTemplates.material()
        
        pieChart.data = chartData
    }
    
    func dataNotAvailable(_ data: String) -> Bool {
        if data == "N/A" { return true }
        return false
    }

}

