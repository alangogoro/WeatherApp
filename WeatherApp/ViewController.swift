//
//  ViewController.swift
//  WeatherApp
//
//  Created by usr on 2020/10/3.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CurrentWeather.getCurrentWeather()
    }

}

struct PropertyKeys {
    static let base_url = "https://api.weatherbit.io/v2.0/"
    static let API_KEY = "3ede3937df284270b1f10f8747aabb36"
    static let aApiKey = "https://api.weatherbit.io/v2.0/current?lang=zh-tw&city=Okinawa,JP&key=3ede3937df284270b1f10f8747aabb36"
}
