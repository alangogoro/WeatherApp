//
//  DateHelper.swift
//  WeatherApp
//
//  Created by usr on 2020/10/11.
//

import Foundation

extension Date {
    
    /**
     將 Date 格式轉換成簡寫字串
     ```
     Date.toShortDate() -> "Oct 1"
     ```
     */
    func toShortDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"// MMM月份縮寫；d天數字
        let dfString = dateFormatter.string(from: self)
        return dfString
        
    }
    
    /**
     將 Date 格式轉換成時刻字串
     ```
     Date.toTime() -> "15:00"
     ```
     */
    func toTime() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"// HH小時；mm分鐘
        let dfString = dateFormatter.string(from: self)
        return dfString
        
    }
    
    /**
     將 Date 格式轉換成星期字串
     ```
     Date.toDayOfWeek() -> "Sunday"
     ```
     */
    func toDayOfWeek() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_TW")
        dateFormatter.dateFormat = "EEEE"// EEEE星期幾
        let dfString = dateFormatter.string(from: self)
        return dfString
        
    }
}
