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
    
    // MARK: vars
    var currentWeather: CurrentWeather!
    private let xib檔案名稱 = "WeatherView"
    
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
        
        // setupViews ...
        setupTableView()
        setupHourlyCollectionView()
        setupInfoCollectionView()
    }
    
    
    private func setupTableView() {
        
    }
    
    private func setupHourlyCollectionView() {
        
    }
    
    private func setupInfoCollectionView() {
        
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
