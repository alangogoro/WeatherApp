//
//  WeatherView.swift
//  WeatherApp
//
//  Created by usr on 2020/10/10.
//

import UIKit

class WeatherView: UIView {
    
    // MARK: IBOutlets
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Vars
    var currentWeather: CurrentWeather!
    var weeklyWeatherForecasts: [WeeklyWeahterForecast] = []
    var hourlyWeatherForecasts: [HourlyForecast] = []
    var weahterInfos: [WeatherInfo] = []
    
    // MARK: PropertyKets
    private let xib檔案名稱 = "WeatherView"
    private let TableViewCell檔案名稱 = "WeatherTableViewCell"
    private let CollectionViewCell檔案名稱_24小時預報 = "ForecastCollectionViewCell"
    private let CollectionViewCell檔案名稱_天氣資訊 = "InfoCollectionViewCell"
    private let reuseIdentifier = "Cell"
    
    // MARK: xib 的初始化||xib INITS
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        mainInit()
    }
    
    private func mainInit() {
        //          loadNibNamed 載入 xib 檔案
        Bundle.main.loadNibNamed(xib檔案名稱, owner: self, options: nil)
        addSubview(mainView)
        //                    bounds 螢幕尺寸
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // setupViews
        setupTableView()
        setupHourlyCollectionView()
        setupInfoCollectionView()
    }
    
    private func setupTableView() {
        /* 註冊 TableView */
        tableView.register(UINib(nibName: TableViewCell檔案名稱,
                                 bundle: Bundle.main),
                           forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        /* 利用 FooterView 去除 Cell 中的間隔線條 */
        tableView.tableFooterView = UIView()
    }
    
    private func setupHourlyCollectionView() {
        /* 註冊 CollectionView */
        hourlyCollectionView.register(UINib(nibName: CollectionViewCell檔案名稱_24小時預報,
                                            bundle: Bundle.main),
                                      forCellWithReuseIdentifier: reuseIdentifier)
        hourlyCollectionView.dataSource = self
    }
    
    private func setupInfoCollectionView() {
        /* 註冊 CollectionView */
        infoCollectionView.register(UINib(nibName: CollectionViewCell檔案名稱_天氣資訊,
                                          bundle: Bundle.main),
                                    forCellWithReuseIdentifier: reuseIdentifier)
        infoCollectionView.dataSource = self
    }
    
    func refreshData() {
        
        setupCurrentWeather()
        
    }
    
    private func setupCurrentWeather() {
        cityNameLabel.text = currentWeather.city
        dateLabel.text = "Today, \(currentWeather.date.shortDate())"
        tempLabel.text = "\(currentWeather.currentTemp)"
        weatherInfoLabel.text = currentWeather.weatherType
    }
    
}


// MARK: TableView Delegates
extension WeatherView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeatherForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            as! WeatherTableViewCell
        cell.generateCell(forecast: weeklyWeatherForecasts[indexPath.row])
        return cell
        
    }
    
}

// MARK: CollectionView Delegates
extension WeatherView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 判斷使用的是哪一個 CollectionView
        if collectionView == hourlyCollectionView {
            return hourlyWeatherForecasts.count
        } else {
            return weahterInfos.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == hourlyCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                          for: indexPath)
                as! ForecastCollectionViewCell
            cell.generateCell(weather: hourlyWeatherForecasts[indexPath.row])
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath)
                as! InfoCollectionViewCell
            cell.generateCell(weatherInfo: weahterInfos[indexPath.row])
            return cell
            
        }
        
    }
    
}
