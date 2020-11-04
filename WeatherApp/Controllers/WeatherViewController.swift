//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by usr on 2020/10/6.
//

import UIKit
import CoreLocation // 使用 GPS 取得使用者地點

class WeatherViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var weatherLocation: WeatherLocation!
    
    // MARK: Vars
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D! // 使用者當前座標
    
    // MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerStart()
        
//        weatherLocation = WeatherLocation(city: "Okinawa", country: "Japan",
//                                          countryCode: "JP", isCurrentLocation: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /* 在畫面大小確定後，加入 xib view
         * 大小設定為和 ScrollView 一樣 */
//        let weatherView = WeatherView()
//        weatherView.frame = CGRect(x: 0, y: 0,
//                                   width: scrollView.bounds.width,
//                                   height: scrollView.bounds.height)
//        scrollView.addSubview(weatherView)
        
        /* 取得即時天氣資訊，並更新 xib view */
        /*
         weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather { (success) in
            weatherView.refreshData()
        }
         */
        
//        getCurrentWeather(weatherView: weatherView)
//        getWeeklyWeather(weatherView: weatherView)
//        getHourlyWeather(weatherView: weatherView)
    }
    
    // MARK: Download Weather
    private func getWeather() {
        
    }
    
    private func getCurrentWeather(weatherView: WeatherView) {
        
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: weatherLocation) { (success) in
            weatherView.refreshData()
        }
        
    }
    private func getWeeklyWeather(weatherView: WeatherView) {
        
        WeeklyWeahterForecast.downloadWeeklyWeatherForecast(location: weatherLocation) { (weatherForecasts) in
            weatherView.weeklyWeatherForecasts = weatherForecasts
            weatherView.tableView.reloadData()
        }
        
    }
    private func getHourlyWeather(weatherView: WeatherView) {
        
        HourlyForecast.downloadHourlyForecastWeather(location: weatherLocation) { (weatherForecasts) in
            weatherView.hourlyWeatherForecasts = weatherForecasts
            weatherView.hourlyCollectionView.reloadData()
        }
        
    }
    
    // MARK: LocationManager
    private func locationManagerStart() {
        
        if locationManager == nil {
            /* 建立 CLLocationManager 並設置定位精確度（最高） */
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            /* ⛔️ 向使用者請求定位權限。 ⛔️
             * 同時必須在 Info.plist 中新增一行
             * Key:
             * Privacy - Location When In Use Usage Description
             * Value:
             * 『提示使用者想要取用他的位置』 */
            locationManager!.requestWhenInUseAuthorization()
            
            locationManager!.delegate = self
        }
        /* 開始監聽定位的更新
         * 有開始就要設定結束，避免離開 app 仍在消耗電量 */
        locationManager!.startMonitoringSignificantLocationChanges()
        
    }
    
    private func locationManagerStop() {
        /* 若有 LocationManager，停止監聽定位 */
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    /// 確認已取得定位權限授權
    private func locationAuthCheck() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            /* 依照定位設置當前位置 */
            currentLocation = locationManager!.location?.coordinate
            
            if currentLocation != nil {
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.logitude = currentLocation.longitude
                
                getWeather()
            } else {
                locationAuthCheck()
            }
        } else {
            locationManager?.requestWhenInUseAuthorization()
            locationAuthCheck()
        }
        
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    
    /* 如果無法取得定位，印出錯誤訊息 */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("取得定位失敗。\(error.localizedDescription)")
    }
    
}
