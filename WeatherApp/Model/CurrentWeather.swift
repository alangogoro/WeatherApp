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
    
    /// 取得城市天氣資料
    func getCurrentWeather(location: WeatherLocation,
                           completion: @escaping (_ success: Bool) -> Void) {
        
        var location_url: String!
        // 如果地點不是所在地（即使用者搜尋新的地點天氣資料）
        if !location.isCurrentLocation {
            location_url = String(format: "https://api.weatherbit.io/v2.0/current?lang=zh-tw&city=%@,%@&key=3ede3937df284270b1f10f8747aabb36", location.city, location.countryCode)
            /* String(format: 字串格式規則, 欲取代的文字)
             * %@ 置入取代文字的格式 */
        } else {
            location_url = CurrentLocation_url
        }
        
        /* Alamofire request&response */
        AF.request(location_url).responseJSON { (response) in
            
            // 檢查是否有結果 response 的型別是 <Any>
            let result = response.result
            
            // 檢查結果是否成功，並使用 SwiftyJSON 解析 ⚠️
            switch(result) {
            case .success(let value):
                let json = JSON(value)
                //print(json)
                //               Dictionary ➡️ Array ➡️ Dictionary
                self._city = json["data"][0]["city_name"].stringValue
                // 日期需要從秒數轉換
                let ts = json["data"][0]["ts"].double
                self._date = currentDateFromTS(ts: ts)
                
                self._weatherType = json["data"][0]["weather"]["description"].stringValue
                self._currentTemp = json["data"][0]["temp"].double
                self._feelsLike = json["data"][0]["app_temp"].double
                self._pressure = json["data"][0]["pres"].double
                self._humidity = json["data"][0]["rh"].double
                self._windSpeed = json["data"][0]["wind_spd"].double
                self._weatherIcon = json["data"][0]["weather"]["icon"].stringValue
                self._visibility = json["data"][0]["vis"].double
                self._uv = json["data"][0]["uv"].double
                self._sunrise = json["data"][0]["sunrise"].stringValue
                self._sunset = json["data"][0]["sunset"].stringValue
                completion(true)
            case .failure(let error):
                self._city = location.city
                completion(false)
                print(error)
            }
            
        }
    }
    
    // MARK: 封裝屬性||private variables
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
    
    // MARK: getters
    var city: String {
        if _city == nil {
            _city = ""
        }
        return _city
    }
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    var uv: Double {
        if _uv == nil {
            _uv = 0.0
        }
        return _uv
    }
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    var feelsLike: Double {
        if _feelsLike == nil {
            _feelsLike = 0.0
        }
        return _feelsLike
    }
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    var pressure: Double {
        if _pressure == nil {
            _pressure = 0.0
        }
        return _pressure
    }
    var humidity: Double {
        if _humidity == nil {
            _humidity = 0.0
        }
        return _humidity
    }
    var windSpeed: Double {
        if _windSpeed == nil {
            _windSpeed = 0.0
        }
        return _windSpeed
    }
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    var visibility: Double {
        if _visibility == nil {
            _visibility = 0.0
        }
        return _visibility
    }
    
}
