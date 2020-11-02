//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by usr on 2020/10/14.
//

import Foundation

/* 遵從 Equatable 協定才能比對2個物件是否相同 */
struct WeatherLocation: Equatable, Codable {
    var city: String!
    var country: String!
    var countryCode: String!
    var isCurrentLocation: Bool!
 }
