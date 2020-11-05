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
    let userDefaults = UserDefaults.standard
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D! // 使用者當前座標
    
    var allLocations: [WeatherLocation] = []
    var allWeatherViews: [WeatherView] = []
    var allWeatherData: [CityTempData] = []
    
    // MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 開始監聽定位
        locationManagerStart()
        scrollView.delegate = self
        
//        weatherLocation = WeatherLocation(city: "Okinawa", country: "Japan",
//                                          countryCode: "JP", isCurrentLocation: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        locationAuthCheck()
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        // 停止監聽定位
        locationManagerStop()
        
    }
    
    
    // MARK: Download Weather
    private func getWeather() {
        
        loadLocationsFromUserDefaults()
        createWeatherViews()
        addWeatherToScrollView()
        setPageControlPageNumber()
        
    }
    
    private func createWeatherViews() {
        
        for _ in allLocations {
            allWeatherViews.append(WeatherView())
        }
        
    }
    
    private func addWeatherToScrollView() {
        
        for i in 0..<allWeatherViews.count {
            /* 將每一個 Location 的資料設置到每一個 WeatherView 中 */
            let weatherView = allWeatherViews[i]
            let location = allLocations[i]
            
            getCurrentWeather(weatherView: weatherView, location: location)
            getWeeklyWeather(weatherView: weatherView, location: location)
            getHourlyWeather(weatherView: weatherView, location: location)
            
            /* 把每一個 WeahterView 設定好畫面位置，addSubview 到 ScrollView 中
             * 最後定義 ScrollView 的內容寬度 */
            let xPosition = self.view.frame.width * CGFloat(i)
            
            weatherView.frame = CGRect(x: xPosition, y: 0,
                                       width: scrollView.bounds.width,
                                       height: scrollView.bounds.height)
            scrollView.addSubview(weatherView)
            
            scrollView.contentSize.width = weatherView.frame.width * CGFloat(i + 1)
            // i + 1 是讓每一張 WeatherView 之間保留間隔，視覺上不會黏在一起
        }
        
    }
    
    
    private func getCurrentWeather(weatherView: WeatherView, location: WeatherLocation) {
        
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: location) { (success) in
            weatherView.refreshData()
        }
        
    }
    private func getWeeklyWeather(weatherView: WeatherView, location: WeatherLocation) {
        
        WeeklyWeahterForecast.downloadWeeklyWeatherForecast(location: location) { (weatherForecasts) in
            weatherView.weeklyWeatherForecasts = weatherForecasts
            weatherView.tableView.reloadData()
        }
        
    }
    private func getHourlyWeather(weatherView: WeatherView, location: WeatherLocation) {
        
        HourlyForecast.downloadHourlyForecastWeather(location: location) { (weatherForecasts) in
            weatherView.hourlyWeatherForecasts = weatherForecasts
            weatherView.hourlyCollectionView.reloadData()
        }
        
    }
    
    
    // MARK: Load Locations from UserDefaults
    private func loadLocationsFromUserDefaults() {
        
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)
        
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            allLocations = try! PropertyListDecoder().decode([WeatherLocation].self, from: data)
            /* 將目前的城市天氣放在第1筆 */
            allLocations.insert(currentLocation, at: 0)
        } else {
            print("UserDefaults 中沒有 Data")
            allLocations.append(currentLocation)
        }
        
    }
    
    // MARK: 設定 PageControl 的屬性（頁數）
    private func setPageControlPageNumber() {
        pageControl.numberOfPages = allWeatherViews.count
    }
    private func updatePageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
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
    /// 確認已取得定位授權，並設置為目前位置
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

extension WeatherViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /* 每當滑動時取得 ScrollView 當前的 X 位置，隨之更新 PageControl */
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        updatePageControlSelectedPage(currentPage: Int(round(value)))
    }
    
}
