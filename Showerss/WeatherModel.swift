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
    let cityName: String
    let temp: Double
    let weather: WeatherIcon
    
    private enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case temp
        case weather
    }
}

struct WeatherIcon: Codable {
    let icon: String
    let description: String
    let code: Int
}
