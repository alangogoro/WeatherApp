//
//  WeeklyWeatherForecast.swift
//  WeatherApp
//
//  Created by usr on 2020/10/6.
//

import Foundation
import Alamofire
import SwiftyJSON

/// 週間預報
class WeeklyWeahterForecast {
    
    // MARK: 封裝屬性||private variables
    private var _date: Date!
    private var _temp: Double!
    private var _weatherIcon: String!
    
    // MARK: getters
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
    init(weatherDic: [String: AnyObject]) {
        let json = JSON(weatherDic)
        self._date = currentDateFromTS(ts: json["ts"].double)
        self._temp = json["temp"].double
        self._weatherIcon = json["weather"]["icon"].stringValue
    }
    
    // 類別方法||下載週間預報
    class func downloadWeeklyWeatherForecast(location: WeatherLocation,
                                             completion: @escaping (_ weatherForecast: [WeeklyWeahterForecast]) -> Void) {
        
        
        var weeklyForecast_url: String!
        // 如果地點不是所在地（即使用者搜尋新的地點天氣資料）
        if !location.isCurrentLocation {
            weeklyForecast_url = String(format: "https://api.weatherbit.io/v2.0/forecast/daily?lang=zh-tw&city=%@,%@&days=7&key=3ede3937df284270b1f10f8747aabb36",
                                        location.city, location.countryCode)
            /* String(format: 字串格式規則, 欲取代的文字)
             * %@ 置入取代文字的格式 */
            print(weeklyForecast_url!)
        } else {
            weeklyForecast_url = CurrentLocationWeeklyForecast_url
        }
        
        /* Alamofire request&response */
        AF.request(weeklyForecast_url).responseJSON { (response) in
            
            // 檢查是否有結果 response 的型別是 <Any>
            let result = response.result
            // 承接預報陣列的結果
            var forecasts: [WeeklyWeahterForecast] = []
            
            switch(result) {
            case .success(let value):
                /* 將資料轉換成每一天預報的 Dictionary */
                if let dic = value as? [String: AnyObject] {
                    if var forecastList = dic["data"] as? [[String: AnyObject]] {
                        
                        forecastList.remove(at: 0)// 移除當天的預報，只取六天
                        for item in forecastList {
                            let forecast = WeeklyWeahterForecast(weatherDic: item)
                            forecasts.append(forecast)
                        }
                        
                    }
                }
                completion(forecasts)
            case .failure(let error):
                completion(forecasts)
                print(error)
            }
        }
    }
}
