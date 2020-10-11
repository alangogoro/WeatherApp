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
     Date.shortDate() -> "Oct 1"
     ```
     */
    func shortDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"// MMM月份縮寫；d天數字
        let string = dateFormatter.string(from: self)
        return string
        
    }
    
    /**
     將 Date 格式轉換成時刻字串
     ```
     Date.time() -> "15:00"
     ```
     */
    func time() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"// HH小時；mm分鐘
        let string = dateFormatter.string(from: self)
        return string
        
    }
}
