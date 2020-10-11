//
//  GlobalHelpers.swift
//  WeatherApp
//
//  Created by usr on 2020/10/6.
//

import Foundation
import UIKit

/** 轉換 Unix 日期格式（秒數）成 Date
 */
func currentDateFromTS(ts: Double?) -> Date? {
    
    if ts != nil {
        return Date(timeIntervalSince1970: ts!)
    } else {
        return Date()
    }
    
}

/** 利用圖片名稱取得 Assets 中的圖片
 */                                     //Optional 因為 Assets 中不一定會有對應圖片
func getWeatherIconFor(_ type: String) -> UIImage? {
    return UIImage(named: type)
}
