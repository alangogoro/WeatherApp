//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by usr on 2020/10/6.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /* 在畫面大小確定後，加入 xib view
         * 大小設定為和 ScrollView 一樣 */
        let weatherView = WeatherView()
        weatherView.frame = CGRect(x: 0, y: 0,
                                   width: scrollView.bounds.width,
                                   height: scrollView.bounds.height)
        scrollView.addSubview(weatherView)
        
        /* 取得即時天氣資訊，並更新 xib view */
        /*
         weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather { (success) in
            weatherView.refreshData()
        }
         */
        
        getCurrentWeather(weatherView: weatherView)
        getWeeklyWeather(weatherView: weatherView)
        getHourlyWeather(weatherView: weatherView)
    }

}

// MARK: Download Weather
private func getCurrentWeather(weatherView: WeatherView) {
    
    weatherView.currentWeather = CurrentWeather()
    weatherView.currentWeather.getCurrentWeather { (success) in
        weatherView.refreshData()
    }
    
}
private func getWeeklyWeather(weatherView: WeatherView) {
    
    WeeklyWeahterForecast.downloadWeeklyWeatherForecast { (weatherForecasts) in
        weatherView.weeklyWeatherForecasts = weatherForecasts
        weatherView.tableView.reloadData()
    }
    
}
private func getHourlyWeather(weatherView: WeatherView) {
    
    HourlyForecast.downloadHourlyForecastWeather { (weatherForecasts) in
        weatherView.hourlyWeatherForecasts = weatherForecasts
        weatherView.hourlyCollectionView.reloadData()
    }
    
}
