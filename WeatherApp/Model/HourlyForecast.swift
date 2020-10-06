//
//  HourlyForecast.swift
//  WeatherApp
//
//  Created by usr on 2020/10/6.
//

import Foundation
import Alamofire
import SwiftyJSON

/// 24小時預報（每小時預報的陣列）
class HourlyForecast {
    
    private var _date: Date!
    private var _temp: Double!
    private var _weatherIcon: String!
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    var temp: Double {
        if _temp == nil {
            _temp = 0.0
        }
        return _temp
    }
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    /// 建構式
    init(weatherDic: Dictionary<String, AnyObject>) {
        
        let json = JSON(weatherDic)
        
        self._date = currentDateFromTS(ts: json["ts"].double)
        self._temp = json["temp"].double
        self._weatherIcon = json["weather"]["icon"].stringValue
        
    }
    
    class func downloadHourlyForecastWeather(completion: @escaping (_ hourlyForecast: [HourlyForecast]) -> Void) {
        
        let hourlyForecast_url = "https://api.weatherbit.io/v2.0/forecast/hourly?lang=zh-tw&city=Okinawa,JP&hours=24&key=3ede3937df284270b1f10f8747aabb36"
        
        /* Alamofire request&response */
        AF.request(hourlyForecast_url).responseJSON { (response) in
            
            // 檢查是否有結果 response 的型別是 <Any>
            let result = response.result
            // 承接預報陣列的結果
            var forecasts: [HourlyForecast] = []
            
            switch(result) {
            case .success(let value):
                /* 將資料轉換成每小時預報的 Dictionary */
                if let dic = value as? Dictionary<String, AnyObject> {
                    if let forecastList = dic["data"] as? [Dictionary<String, AnyObject>] {
                        
                        for item in forecastList {
                            let forecast = HourlyForecast(weatherDic: item)
                            forecasts.append(forecast)
                        }
                         
                    }
                }
                completion(forecasts)// 預報陣列
            case .failure(let error):
                completion(forecasts)// 空陣列
                print(error)
            }
        }
        
    }
}
