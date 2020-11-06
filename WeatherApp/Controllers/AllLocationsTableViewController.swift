//
//  AllLocationsTableViewController.swift
//  WeatherApp
//
//  Created by usr on 2020/10/14.
//

import UIKit

protocol AllLocationsTableViewControllerDelegate {
    func didChooseLocation(atIndex: Int, shouldRefresh: Bool)
}

class AllLocationsTableViewController: UITableViewController {
    // MARK: IBOutlets
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var tempSegmentedControl: UISegmentedControl!
    
    // MARK: Vars
    var savedLocations: [WeatherLocation]?
    var weatherData: [CityTempData]?
    var userDefaults = UserDefaults.standard
    
    var delegate: AllLocationsTableViewControllerDelegate?
    var shouldRefresh = false
    
    private let reuseIdentifier = "Cell"
    private let segueId = "ChooseCitySegue"
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /* 設置 TableView 的 Footer */
        tableView.tableFooterView = footerView
        
        loadLocationsFromUserDefaults()
        loadTempFormatFromUserDefaults()
        
    }
    
    // MARK: IBActions
    @IBAction func tempSegmentValueChanged(_ sender: UISegmentedControl) {
        updateTempFormatInUserDefaults(newValue: sender.selectedSegmentIndex)
    }
    

    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! MainWeatherTableViewCell
        if weatherData != nil {
            cell.generateCell(weatherData: weatherData![indexPath.row])
        }
        return cell
    }
    
    // MARK: TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消選取 row 的動畫
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didChooseLocation(atIndex: indexPath.row, shouldRefresh: shouldRefresh)
        self.dismiss(animated: true)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // 第一行（本地城市不能被刪除，其它可以）
        return indexPath.row != 0
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let locationToDelete = weatherData?[indexPath.row]
            weatherData?.remove(at: indexPath.row)
            
            /* 從 UserDefaults 刪除地點 */
            removeLocationAndSave(city: locationToDelete!.city)
            tableView.reloadData()
        }
        
    }
    private func removeLocationAndSave(city: String) {
        
        if savedLocations != nil {
            for i in 0..<savedLocations!.count {
                let location = savedLocations![i]
                if location.city == city {
                    
                    savedLocations!.remove(at: i)
                    saveLocationsToUserDefaults()
                    
                    return
                }
            }
        }
        
    }
    
    // MARK: - 使用 UserDefaults
    private func saveLocationsToUserDefaults() {
        shouldRefresh = true
        
        /* 儲存至 UserDefaults 必須先用 PropertyListEncoder 編碼 */
        let value = try? PropertyListEncoder().encode(savedLocations!)
        userDefaults.setValue(value, forKey: "Locations")
        /*          .synchronize() */
        userDefaults.synchronize()
    }
    
    private func loadLocationsFromUserDefaults() {
        
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode([WeatherLocation].self, from: data)
        }
        print("UserDefaluts 中有\(savedLocations?.count ?? 0)筆 WeatherLocation")
        
    }
    /** 切換華氏攝氏，並儲存設定至偏好設定 */
    private func updateTempFormatInUserDefaults(newValue: Int) {
        shouldRefresh = true
        userDefaults.setValue(newValue, forKey: "TempFormat")
        userDefaults.synchronize()
    }
    private func loadTempFormatFromUserDefaults() {
        if let index = userDefaults.value(forKey: "TempFormat") {
            tempSegmentedControl.selectedSegmentIndex = index as! Int
        } else {
            tempSegmentedControl.selectedSegmentIndex = 0
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            let destination = segue.destination as! ChooseCityViewController
            destination.delegate = self
        }
    }
}


extension AllLocationsTableViewController: ChooseCityViewControllerDelegate {
    func didAdd(newLocation: WeatherLocation) {
        shouldRefresh = true
        weatherData?.append(CityTempData(city: newLocation.city, temp: 0.0))
        tableView.reloadData()
        //print("已新增城市", newLocation.country, newLocation.city)
    }
}
