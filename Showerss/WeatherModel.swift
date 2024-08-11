//
//  WeatherModel.swift
//  Showerss
//
//  Created by M sai deepthi on 11/08/24.
//

import Foundation

struct WeatherResponse: Codable{
    let data: [WeatherData]
}

struct WeatherData: Codable {
    let city_name: String
    let temp: Double
    let weather: WeatherIcon
}

struct WeatherIcon: Codable {
    let icon: String
}
