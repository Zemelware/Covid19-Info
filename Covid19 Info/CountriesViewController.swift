//
//  CountriesViewController.swift
//  Covid19 Info
//
//  Created by Ethan Zemelman on 2020-08-13.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import UIKit

var selectedIndex: Int?

var countryNames = [String]()
var totalCasesArray = [String]()
var deathsArray = [String]()
var recoveredArray = [String]()
var activeCasesArray = [String]()
var criticalCasesArray = [String]()
var newCasesArray = [String]()
var newDeathsArray = [String]()

var filteredCountries = [String]()
var filteredTotalCases = [String]()
var filteredDeaths = [String]()
var filteredRecovered = [String]()
var filteredActiveCases = [String]()
var filteredCriticalCases = [String]()
var filteredNewCases = [String]()
var filteredNewDeaths = [String]()

class CountriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    var refreshTimer: NSObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = refresher
        
        refreshTimer = Timer.scheduledTimer(timeInterval: 10*60, target: self, selector: #selector(timerRefreshData), userInfo: nil, repeats: true)
        
        requestData()
    }

    func requestData() {
        getData() { results in
            switch results {
            case .success(let data):
                
                for i in 1...data.count - 1 {
                    countryNames.append(data[i].country)
                    totalCasesArray.append("\(data[i].cases.withCommas())")
                    deathsArray.append("\(data[i].deaths.withCommas())")
                    recoveredArray.append("\(data[i].recovered?.withCommas() ?? "N/A")")
                    activeCasesArray.append("\(data[i].active?.withCommas() ?? "N/A")")
                    criticalCasesArray.append("\(data[i].critical.withCommas())")
                    newCasesArray.append("\(data[i].todayCases.withCommas())")
                    newDeathsArray.append("\(data[i].todayDeaths.withCommas())")
                }
                
                filteredCountries = countryNames
                filteredTotalCases = totalCasesArray
                filteredDeaths = deathsArray
                filteredRecovered = recoveredArray
                filteredActiveCases = activeCasesArray
                filteredCriticalCases = criticalCasesArray
                filteredNewCases = newCasesArray
                filteredNewDeaths = newDeathsArray
                
                self.tableView.reloadData()
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

                var indexes = [Int]()
                for i in 0...filteredCountries.count - 1 {
                    indexes.append(countryNames.firstIndex(of: filteredCountries[i])!)
                }
                
                countryNames.removeAll()
                totalCasesArray.removeAll()
                deathsArray.removeAll()
                recoveredArray.removeAll()
                activeCasesArray.removeAll()
                criticalCasesArray.removeAll()
                newCasesArray.removeAll()
                newDeathsArray.removeAll()
                filteredCountries.removeAll()
                filteredTotalCases.removeAll()
                filteredDeaths.removeAll()
                filteredRecovered.removeAll()
                filteredActiveCases.removeAll()
                filteredCriticalCases.removeAll()
                filteredNewCases.removeAll()
                filteredNewDeaths.removeAll()
                
                for i in 1...data.count - 1 {
                    countryNames.append(data[i].country)
                    totalCasesArray.append("\(data[i].cases.withCommas())")
                    deathsArray.append("\(data[i].deaths.withCommas())")
                    recoveredArray.append("\(data[i].recovered?.withCommas() ?? "0")")
                    activeCasesArray.append("\(data[i].active?.withCommas() ?? "0")")
                    criticalCasesArray.append("\(data[i].critical.withCommas())")
                    newCasesArray.append("\(data[i].todayCases.withCommas())")
                    newDeathsArray.append("\(data[i].todayDeaths.withCommas())")
                }
                
                for i in 0...countryNames.count - 1 {
                    if indexes.contains(i) {
                        filteredCountries.append(countryNames[i])
                        filteredTotalCases.append(totalCasesArray[i])
                        filteredDeaths.append(deathsArray[i])
                        filteredRecovered.append(recoveredArray[i])
                        filteredActiveCases.append(activeCasesArray[i])
                        filteredCriticalCases.append(criticalCasesArray[i])
                        filteredNewCases.append(newCasesArray[i])
                        filteredNewDeaths.append(newDeathsArray[i])
                    }
                }
                
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func refresh() {
        getData() { results in
            switch results {
            case .success(let data):

                var indexes = [Int]()
                for i in 0...filteredCountries.count - 1 {
                    indexes.append(countryNames.firstIndex(of: filteredCountries[i])!)
                }
                
                countryNames.removeAll()
                totalCasesArray.removeAll()
                deathsArray.removeAll()
                recoveredArray.removeAll()
                activeCasesArray.removeAll()
                criticalCasesArray.removeAll()
                newCasesArray.removeAll()
                newDeathsArray.removeAll()
                filteredCountries.removeAll()
                filteredTotalCases.removeAll()
                filteredDeaths.removeAll()
                filteredRecovered.removeAll()
                filteredActiveCases.removeAll()
                filteredCriticalCases.removeAll()
                filteredNewCases.removeAll()
                filteredNewDeaths.removeAll()
                
                for i in 1...data.count - 1 {
                    countryNames.append(data[i].country)
                    totalCasesArray.append("\(data[i].cases.withCommas())")
                    deathsArray.append("\(data[i].deaths.withCommas())")
                    recoveredArray.append("\(data[i].recovered?.withCommas() ?? "0")")
                    activeCasesArray.append("\(data[i].active?.withCommas() ?? "0")")
                    criticalCasesArray.append("\(data[i].critical.withCommas())")
                    newCasesArray.append("\(data[i].todayCases.withCommas())")
                    newDeathsArray.append("\(data[i].todayDeaths.withCommas())")
                }
                
                for i in 0...countryNames.count - 1 {
                    if indexes.contains(i) {
                        filteredCountries.append(countryNames[i])
                        filteredTotalCases.append(totalCasesArray[i])
                        filteredDeaths.append(deathsArray[i])
                        filteredRecovered.append(recoveredArray[i])
                        filteredActiveCases.append(activeCasesArray[i])
                        filteredCriticalCases.append(criticalCasesArray[i])
                        filteredNewCases.append(newCasesArray[i])
                        filteredNewDeaths.append(newDeathsArray[i])
                    }
                }
                
                self.tableView.reloadData()
                
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
    
    // MARK: Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.countryName.text = filteredCountries[indexPath.row]
        cell.totalCases.text = "Cases: \(filteredTotalCases[indexPath.row])"
        cell.deaths.text = "Deaths: \(filteredDeaths[indexPath.row])"
        cell.recovered.text = "Recovered: \(filteredRecovered[indexPath.row])"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "countrySegue", sender: self)
    }
    
    // MARK: Search Bar Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCountries = []
        filteredTotalCases = []
        filteredDeaths = []
        filteredRecovered = []
        filteredActiveCases = []
        filteredCriticalCases = []
        filteredNewCases = []
        filteredNewDeaths = []
        
        if searchText == "" {
            filteredCountries = countryNames
            filteredTotalCases = totalCasesArray
            filteredDeaths = deathsArray
            filteredRecovered = recoveredArray
            filteredActiveCases = activeCasesArray
            filteredCriticalCases = criticalCasesArray
            filteredNewCases = newCasesArray
            filteredNewDeaths = newDeathsArray
        } else {
            for i in 0...countryNames.count - 1 {
                if countryNames[i].lowercased().contains(searchText.lowercased()) {
                    filteredCountries.append(countryNames[i])
                    filteredTotalCases.append(totalCasesArray[i])
                    filteredDeaths.append(deathsArray[i])
                    filteredRecovered.append(recoveredArray[i])
                    filteredActiveCases.append(activeCasesArray[i])
                    filteredCriticalCases.append(criticalCasesArray[i])
                    filteredNewCases.append(newCasesArray[i])
                    filteredNewDeaths.append(newDeathsArray[i])
                }
            }
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredCountries = countryNames
        filteredTotalCases = totalCasesArray
        filteredDeaths = deathsArray
        filteredRecovered = recoveredArray
        filteredActiveCases = activeCasesArray
        filteredCriticalCases = criticalCasesArray
        filteredNewCases = newCasesArray
        filteredNewDeaths = newDeathsArray
        
        searchBar.showsCancelButton = false
        
        searchBar.text = ""
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            if searchBar.text != "" { cancelButton.isEnabled = true }
            else { searchBar.showsCancelButton = false }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        // If the user scrolls, keep the cancel button enabled
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            if searchBar.text != "" { cancelButton.isEnabled = true }
            else { searchBar.showsCancelButton = false }
        }
    }
    
}
