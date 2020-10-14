//
//  ViewController.swift
//  WeatherApp
//
//  Created by usr on 2020/10/3.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         let currentWeather = CurrentWeather()
        /* 只有在接收到 callback 結果（Bool）以後，才會執行 {} 裡的程式 */
        currentWeather.getCurrentWeather { (success) in
            if success {
                print("City is:", currentWeather.city)
            }
        }
        HourlyForecast.downloadHourlyForecastWeather { (hourlyForecasts) in
            for data in hourlyForecasts {
                print("Forecast data: \(data.temp) \(data.date)")
            }
        }
        WeeklyWeahterForecast.downloadWeeklyWeatherForecast { (weeklyForecast) in
            for forecast in weeklyForecast {
                print("Forecast info: \(forecast.date) \(forecast.temp)")
            }
        }
         */
        
    }

}

struct PropertyKeys {
    static let base_url = "https://api.weatherbit.io/v2.0/"
    static let API_KEY = "3ede3937df284270b1f10f8747aabb36"
    static let aApiKey = "https://api.weatherbit.io/v2.0/current?lang=zh-tw&city=Okinawa,JP&key=3ede3937df284270b1f10f8747aabb36"
}
