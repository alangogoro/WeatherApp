//
//  APIurls.swift
//  WeatherApp
//
//  Created by usr on 2020/10/14.
//

import Foundation

let CurrentLocation_url =
"https://api.weatherbit.io/v2.0/current?lang=zh-tw&lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.logitude!)&key=3ede3937df284270b1f10f8747aabb36"
let CurrentLocationWeeklyForecast_url = "https://api.weatherbit.io/v2.0/forecast/daily?lang=zh-tw&lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.logitude!)&days=7&key=3ede3937df284270b1f10f8747aabb36"
let CurrentLocationHourlyForecast_url = "https://api.weatherbit.io/v2.0/forecast/hourly?lang=zh-tw&lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.logitude!)&hours=24&key=3ede3937df284270b1f10f8747aabb36"
