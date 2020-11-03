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
    let userDefaults = UserDefaults.standard
    var savedLocations: [WeatherLocation]?
    private let reuseIdentifier = "FilteredCityCell"
    private let 檔案路徑 = "location"
    private let 格式 = "csv"
    
    // MARK: 搜尋欄|| Search Controller
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        /* ⭐️ 將 SearchBar 指定為 TableView 的 Header ⭐️ */
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
        
        setupTapGesture()
        loadLocationsFromSCV()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFromUserDefaults()
        
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
    
    // MARK: SearchController
    private func setupSearchController() {
        
        searchController.searchBar.placeholder = "搜尋都市或國家"
        /*              .searchResultsUpdater 搜尋結果的承接對象 */
        searchController.searchResultsUpdater = self
        /* 出現搜尋結果時是否淡化搜尋欄 */
        searchController.dimsBackgroundDuringPresentation = false
        /* 出現搜尋結果時覆蓋效果... */
        definesPresentationContext = true
        
        /* 永遠/短暫顯示搜尋欄 */
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        /* 搜尋欄大小自動調整 */
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage()
    }
    
    // MARK: UserDefaults
    private func loadFromUserDefaults() {
        
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode([WeatherLocation].self, from: data)
        }
        print(savedLocations?.last?.city ?? "UserDefaluts 沒有 WeatherLocation")
        
    }
    private func saveToUserDefaults(location: WeatherLocation) {
        
        if savedLocations != nil {
            /* 如果地點尚未被儲存過 */
            /*                 .contains() 若要比對物件需要遵從 Equatable 協定 */
            if !savedLocations!.contains(location) {
                savedLocations!.append(location)
            }
            
        } else {
            savedLocations = [location]
        }
        
        /* 利用 PropertyListEncoder 編碼後才能放入 UserDufaults */
        let value = try? PropertyListEncoder().encode(savedLocations)
        userDefaults.setValue(value, forKey: "Locations")
        userDefaults.synchronize()
        
    }
    
    // MARK: Gesture 設置手勢
    private func setupTapGesture() {
        /* 定義 UIGestureRecognizer 手勢並加入到 TableView 的背景 view 上 */
        let tap = UIGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }
    @objc func tableTapped() {
        
        /* 若在搜尋狀態，dismiss 掉搜尋結果列和本頁 */
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
        
    }
    
}


// MARK: SearchBar -- UISearchResultUpdating
extension ChooseCityViewController: UISearchResultsUpdating {
    
    func filterContentForSearchText(searchText: String,
                                    scope: String = "All") {
        
        /* 利用搜尋文字篩選並回傳符合條件的地點 */
        filteredLocations = locations.filter({ (location) -> Bool in
            
            return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased())
            
        })
        tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}

// MARK: TableView Delegates
extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath)
        
        let location = filteredLocations[indexPath.row]
        cell.textLabel?.text = location.city
        cell.detailTextLabel?.text = location.country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* 儲存天氣地點 */
        // 取消 row 被選取的動畫
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveToUserDefaults(location: filteredLocations[indexPath.row])
        
        /* 若在搜尋狀態，dismiss 掉搜尋結果列和本頁 */
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
        
    }
    
}
