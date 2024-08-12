//
//  DataManager.swift
//  Showerss
//
//  Created by M sai deepthi on 11/08/24.
//

import Foundation

struct DataManager {
    private let apiKey = "17ad1e4a39c149b89fd0212c50a735be"
    typealias Completion = (WeatherResponse?) -> Void
    
    func fetchWeatherData(cityName: String, completion: @escaping Completion) {
        let url = "https://api.weatherbit.io/v2.0/current?city=\(cityName)&key=\(apiKey)&include=minutely"
        let NetworkManager = NetworkManager(url: url)
        NetworkManager.DownloadDataFromURL { result in
            switch result {
            case.success(let data):
                do{
                    let weatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    if let firstWeatherData = weatherData.data.first{
                        print(firstWeatherData.cityName,firstWeatherData.temp)
                    }
                    completion(weatherData)
                }catch{
                    print("Error:- \(error.localizedDescription)")
//                    completion([])
                }
            case.failure(let error):
                print("Error:- \(error.localizedDescription)")
            }
        }
    }
}
