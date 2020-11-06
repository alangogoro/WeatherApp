//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by usr on 2020/10/11.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: 設置 CollectionViewCell
    func generateCell(weather: HourlyForecast) {
        timeLabel.text = weather.date.toTime()
        weatherIconImageView.image = getWeatherIconFor(weather.weatherIcon)
        tempLabel.text = String(format: "%.0f%@",
                                weather.temp,
                                returnTempFormatFromUserDefaults())
    }
    
}
