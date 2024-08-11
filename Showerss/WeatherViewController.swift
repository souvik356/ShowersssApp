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
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loader.startAnimating()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        searchBtn.layer.cornerRadius = 10
        searchBtn.clipsToBounds = true
    }
    
    @IBAction func searchCityBtnPressed(_ sender: Any) {
        let enteredCityName = cityNameTextField.text
        if let cityName = enteredCityName, !cityName.isEmpty{
            WeatherViewModel().getWeatherData(cityName: cityName) { weatherResponse in
                if let weatherData = weatherResponse?.data.first{
                    DispatchQueue.main.async{
                        self.temperatureLbl.text = String("\(weatherData.temp)°C")
                        self.cityNameLbl.text = weatherData.city_name
                        self.loader.stopAnimating()
                        self.loader.hidesWhenStopped = true
                    }
                }
                else {
                    DispatchQueue.main.async{
                        self.temperatureLbl.text = "Error updating temperature"
                        self.cityNameLbl.text = "Error updating location"
                        self.loader.stopAnimating()
                        self.loader.hidesWhenStopped = true
                    }
                }
            }
        }
        else{
            print("Empty fields not allowed")
//            let alert = UIAlertController(title: "Error", message: "Please type City name", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
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
                                    self.cityNameLbl.text = weatherData.city_name
                                    self.loader.stopAnimating()
                                    self.loader.hidesWhenStopped = true
                                }
                            }
                            else{
                                DispatchQueue.main.async{
                                    self.temperatureLbl.text = "Error updating temperature"
                                    self.cityNameLbl.text = "Error updating location"
                                    self.loader.stopAnimating()
                                    self.loader.hidesWhenStopped = true
                                }
                            }
                        }
                    }
                }
            }
        }
        locationManager.stopUpdatingLocation()
    }
}

