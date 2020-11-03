//
//  AllLocationsTableViewController.swift
//  WeatherApp
//
//  Created by usr on 2020/10/14.
//

import UIKit

class AllLocationsTableViewController: UITableViewController {
    
    // MARK: Vars
    var savedLocations: [WeatherLocation]?
    
    private let reuseIdentifier = "Cell"
    private let segueId = "ChooseCitySegue"
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromUserDefaults()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath)

        // Configure the cell...

        return cell
    }
    
    // MARK: 使用 UserDefaults
    private func loadFromUserDefaults() {
        
        if let data = UserDefaults.standard.value(forKey: "Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode([WeatherLocation].self, from: data)
        }
        print("UserDefaluts 中有\(savedLocations?.count ?? 0)筆 WeatherLocation")
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            let destination = segue.destination as! ChooseCityViewController
            destination.delegate = self
        }
    }
}


extension AllLocationsTableViewController: ChooseCityViewControllerDelegate {
    func didAdd(newLocation: WeatherLocation) {
        //print("已新增城市", newLocation.country, newLocation.city)
    }
}
