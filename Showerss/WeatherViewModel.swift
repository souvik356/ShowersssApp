//
//  WeatherViewModel.swift
//  Showerss
//
//  Created by M sai deepthi on 11/08/24.
//

import Foundation

struct WeatherViewModel {
    typealias Completion = (WeatherResponse?) -> Void
    func getWeatherData(cityName: String, completion: @escaping Completion) {
        DataManager().fetchWeatherData(cityName: cityName) { data in
            completion(data)
        }
    }
}
