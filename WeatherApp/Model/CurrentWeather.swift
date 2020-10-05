//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by usr on 2020/10/5.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    // Class Function 類別函式
    // 取得城市天氣資料
    class func getCurrentWeather() {
        
        let location_url = "https://api.weatherbit.io/v2.0/current?lang=zh-tw&city=Okinawa,JP&key=3ede3937df284270b1f10f8747aabb36"
        
        /* Alamofire request&response */
        AF.request(location_url).responseJSON { (response) in
            
            // 檢查是否有結果 response 的型別是 <Any>
            let result = response.result
            
            // 檢查結果是否成功，並使用 SwiftyJSON 解析 ⚠️
            switch(result) {
            case .success(let value):
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    // 封裝屬性
    private var _city: String!
    private var _date: Date!
    private var _currentTemp: Double!//currentTemo???
    private var _feelsLike:   Double!
    private var _uv: Double!
    private var _weatherType: String!
    private var _pressure:  Double!//mb
    private var _humidity:  Double!// %
    private var _windSpeed: Double!//m/s
    private var _weatherIcon: String!
    private var _visibility:  Double!//KM
    private var _sunrise: String!
    private var _sunset:  String!
    
    var city: String {
        if _city == nil {
            _city = ""
        }
        return _city
    }
}
