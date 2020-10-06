//
//  GlobalHelpers.swift
//  WeatherApp
//
//  Created by usr on 2020/10/6.
//

import Foundation

/** 轉換 Unix 日期格式（秒數）成 Date
 */
func currentDateFromTS(ts: Double?) -> Date? {
    
    if ts != nil {
        return Date(timeIntervalSince1970: ts!)
    } else {
        return Date()
    }
    
}
