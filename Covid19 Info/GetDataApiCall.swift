//
//  GetDataApiCall.swift
//  Covid19 Info
//
//  Created by Ethan Zemelman on 2020-08-12.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import Foundation
import UIKit

struct CoronaInfo: Codable {
    let country: String
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int?
    let active: Int?
    let critical: Int
    let casesPerOneMillion: Int
    let deathsPerOneMillion: Int
    let totalTests: Int
    let testsPerOneMillion: Int
}

func getData(completed: @escaping (Result<[CoronaInfo], Error>) -> ()) {
    let url = "https://coronavirus-19-api.herokuapp.com/countries"
    
    URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
        // Make sure that data isn't nil
        if let error = error, data == nil {
            print("NO INTERNET")
            DispatchQueue.main.async {
                completed(.failure(error))
            }
            return
        }
        
        guard let data = data else { return }
        
        do {
            // Convert data from bytes to the custom object (Known as JSON decoding)
            let results = try JSONDecoder().decode([CoronaInfo].self, from: data)
            
            DispatchQueue.main.async {
                completed(.success(results))
            }
        } catch { DispatchQueue.main.async {completed(.failure(error))} }
        
    }.resume()
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

extension String {
    func withoutCommas() -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.number(from: self) as! Double
    }
}
