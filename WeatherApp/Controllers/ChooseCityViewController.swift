//
//  ChooseCityViewController.swift
//  WeatherApp
//
//  Created by usr on 2020/10/14.
//

import UIKit

class ChooseCityViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Vars
    var locations: [WeatherLocation] = []
    var filteredLocations: [WeatherLocation] = []
    private let reuseIdentifier = "FilteredCityCell"
    private let 檔案路徑 = "location"
    private let 格式 = "csv"
    
    // MARK: 搜尋列|| Search Controller
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLocationsFromSCV()
        
    }
    
    // MARK: Get Locations
    /// 從 CSV 檔讀取所有地點
    private func loadLocationsFromSCV() {
        
        /* 取用專案 bundle 內的檔案
                      Bundle.main.path(forResource: , ofType: ) */
        if let path = Bundle.main.path(forResource: 檔案路徑, ofType: 格式) {
            parseCSVAt(url: URL(fileURLWithPath: path))
        }
        
    }
    /// 分析 CSV 檔案
    private func parseCSVAt(url: URL) {
        /* 分析可能會失敗（throws），需要使用 do...catch 包起程式碼 */
        do {
            
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            /* 利用 String.components(separatedBy: )
             * 將讀出的字串拆分轉換為
             * [[城市, 國家, 代碼], [城市, 國家, 代碼], ...]
             * 的二維陣列 */
            if let dataAry = dataEncoded?.components(separatedBy: "\n")
                .map({ $0.components(separatedBy: ",") }) {
                
                // 行數計數，便於刪掉多餘的第一行
                var lineNo = 0
                for line in dataAry {
                    /* 只取用包含了城市,國家,代碼3種資訊的行數 */
                    if line.count > 2 && lineNo != 0 {
                        createLocation(line: line)
                    }
                    lineNo += 1
                }
                
            }
            
        } catch {
            print("Error reading CSV file, ", error.localizedDescription)
        }
    }
    private func createLocation(line: [String]) {
        let weatherLocation = WeatherLocation(city: line[0],       //可寫成 .first!
                                              country: line[1],
                                              countryCode: line[2],//可寫成 .last!
                                              isCurrentLocation: false)
        locations.append(weatherLocation)
    }
    
}


// MARK: TableView Delegates
extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Save location
        
    }
}