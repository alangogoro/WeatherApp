//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by usr on 2020/10/13.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: 設置 TableViewCell
    func generateCell(forecast: WeeklyWeahterForecast) {
        
        dayOfWeekLabel.text = forecast.date.toDayOfWeek()
        weatherIconImageView.image = getWeatherIconFor(forecast.weatherIcon)
        tempLabel.text = "\(forecast.temp)"
        
    }
    
}
