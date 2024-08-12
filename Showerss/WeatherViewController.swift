//
//  ViewController.swift
//  Showerss
//
//  Created by M sai deepthi on 11/08/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var descriptionOfWeather: UILabel!
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
        self.updateLocationManager()
        loader.startAnimating()
    }
    
    private func updateUI() {
        searchBtn.layer.cornerRadius = 10
        searchBtn.clipsToBounds = true
    }
    
    private func updateLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func searchCityBtnPressed(_ sender: Any) {
        let enteredCityName = cityNameTextField.text
        if let cityName = enteredCityName, !cityName.isEmpty{
            WeatherViewModel().getWeatherData(cityName: cityName) { weatherResponse in
                if let weatherData = weatherResponse?.data.first{
                    DispatchQueue.main.async{
                        self.temperatureLbl.text = String("\(weatherData.temp)°C")
                        self.cityNameLbl.text = weatherData.cityName
                        self.updateWeatherIcon(weatherCode: weatherData.weather.code)
                        self.descriptionOfWeather.text = weatherData.weather.description
                        self.loader.stopAnimating()
                        self.loader.hidesWhenStopped = true
                    }
                }
                else {
                    DispatchQueue.main.async{
                        self.updateUIForError()
                    }
                }
            }
        }
        else{
            print("Empty fields not allowed")
            let alert = UIAlertController(title: "Error", message: "Please type City name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func updateWeatherIcon(weatherCode: Int) {
        let weatherIcon: String
        switch weatherCode {
        case 200...233:
            weatherIcon = "scattered-thunderstorms"
        case 300...302:
            weatherIcon = "drizzle"
        case 500...522:
            weatherIcon = "rain"
        case 600...623:
            weatherIcon = "snow"
        case 700...751:
            weatherIcon = "fog"
        case 800:
            weatherIcon = "sun"
        case 801...804:
            weatherIcon = "cloudy"
        case 900:
            weatherIcon = "rain"
        default:
            weatherIcon = "default"
        }
        DispatchQueue.main.async {
            self.weatherIcon.image = UIImage(named: weatherIcon)
        }
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            if let location = locations.first{
                print("latitude:- \(location.coordinate.latitude) , longitude:- \(location.coordinate.longitude)")
                geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    if let placemark = placemarks?.first {
                        let cityName = placemark.locality
                        print(cityName ?? "")
                        WeatherViewModel().getWeatherData(cityName: cityName ?? "") { weatherResponse in
                            if let weatherData = weatherResponse?.data.first{
                                DispatchQueue.main.async{
                                    self.temperatureLbl.text = String("\(weatherData.temp) °C")
                                    self.cityNameLbl.text = weatherData.cityName
                                    self.updateWeatherIcon(weatherCode: weatherData.weather.code)
                                    self.descriptionOfWeather.text = weatherData.weather.description
                                    self.loader.stopAnimating()
                                    self.loader.hidesWhenStopped = true
                                }
                            }
                            else{
                                DispatchQueue.main.async{
                                    self.updateUIForError()
                                }
                            }
                        }
                    }
                }
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    private func updateUIForError() {
        self.temperatureLbl.text = "Error updating temperature"
        self.cityNameLbl.text = "Error updating location"
        self.loader.stopAnimating()
        self.loader.hidesWhenStopped = true
    }
}

