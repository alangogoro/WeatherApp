//
//  MainWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by usr on 2020/11/3.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func generateCell(weatherData: CityTempData) {
        cityLabel.text = weatherData.city
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.text = String(format: "%.0f %@", weatherData.temp, "°C")
        // TODO: 讓溫度文字可以隨攝氏華氏變化
    }

}
