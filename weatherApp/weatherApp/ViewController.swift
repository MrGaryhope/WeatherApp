//
//  ViewController.swift
//  weatherApp
//
//  Created by Егор Максимов on 17.08.2021.
//

import UIKit
import CoreLocation

//custom cell: collection view
// API / request to get the data

enum Icon: String, Codable {
    case the01D = "01d" // clear sky
    case the01N = "01n" // clear sky
    case the02D = "02d" // few clouds
    case the02N = "02n" // few clouds
    case the03D = "03d" // scattered clouds
    case the03N = "03n" // scattered clouds
    case the04D = "04d" // overcast clouds
    case the04N = "04n" // overcast clouds
    case the10N = "10n" // rain
    case the10D = "10d" // rain
    case the13D = "13d" // snow
    case the13N = "13n" // snow
}
enum Main: String, Codable {
    case clear = "Clear", clouds = "Clouds", rain = "Rain", snow = "Snow"
}
enum Description: String, Codable {
    case clearSky = "clear sky", fewClouds = "few clouds", scatteredClouds = "scattered clouds", brokenClouds = "broken clouds", lightRain = "light rain", overcastClouds = "overcast clouds", heavyIntensityRain = "heavy intensity rain", moderateRain = "moderate rain", light_snow = "light snow", snow = "snow", rainAndSnow = "rain and snow"
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var table : UITableView!
    
    let APIkey = "15ff0a67eb35717051bf4b5833252310" 
    
    var models = [Daily]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var currentWeather: Current?
    var hourlyWeather = [Current]()
    var json: Root?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupLocation()
    }
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&appid=\(APIkey)&units=metric"
        

//        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=68.044326&lon=25.911087&appid=\(APIkey)&units=metric"

        print(url)
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.json = try decoder.decode(Root.self, from: data)
            }
            catch {
                print("decode error: \(error)")
                print("localized error: \(error.localizedDescription)")
            }
            
            guard let result = self.json else {
                return
            }
            
            let entries = result.daily
            self.models.append(contentsOf: entries)
            
            let current = result.current
            self.currentWeather = current
            
            self.hourlyWeather = result.hourly
            
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
            }
        }).resume()
    }
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 2.25))
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: headerView.frame.size.width - 20, height: headerView.frame.size.height / 5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 5 + locationLabel.frame.size.height, width: headerView.frame.size.width - 20, height: headerView.frame.size.height / 5))
        let imageView = UIImageView(frame: CGRect(x: headerView.frame.size.width / 2.75, y: 20 + summaryLabel.frame.size.height + locationLabel.frame.size.height, width: 100, height: headerView.frame.size.height / 2))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20 + summaryLabel.frame.size.height + locationLabel.frame.size.height, width: headerView.frame.size.width - 20, height: headerView.frame.size.height / 2))
        
        let tempSummary = self.currentWeather!.weather.map { ($0 ).main }

        let decidedIcon = self.currentWeather!.weather.map { ($0 ).icon }
        
        if (decidedIcon.contains(Icon.the01D)) {
            imageView.image = UIImage(named: "icClear")
        } else if (decidedIcon.contains(Icon.the01N)) {
            imageView.image = UIImage(named: "icClear")
        } else if (decidedIcon.contains(Icon.the02D)) {
            imageView.image = UIImage(named: "icCloudy")
        } else if (decidedIcon.contains(Icon.the02N)) {
            imageView.image = UIImage(named: "icCloudy")
        } else if (decidedIcon.contains(Icon.the03D)) {
            imageView.image = UIImage(named: "icCloud")
        } else if (decidedIcon.contains(Icon.the03N)) {
            imageView.image = UIImage(named: "icCloud")
        } else if (decidedIcon.contains(Icon.the04N)) {
            imageView.image = UIImage(named: "icCloud")
        } else if (decidedIcon.contains(Icon.the04D)) {
            imageView.image = UIImage(named: "icCloud")
        } else if (decidedIcon.contains(Icon.the10N)) {
            imageView.image = UIImage(named: "icRain")
        } else if (decidedIcon.contains(Icon.the10D)) {
            imageView.image = UIImage(named: "icRain")
        } else if (decidedIcon.contains(Icon.the13D)) {
            imageView.image = UIImage(named: "icSnow")
        }
        
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(imageView)
        headerView.addSubview(tempLabel)
        
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        imageView.contentMode = .scaleAspectFill
        tempLabel.textAlignment = .center
        
        locationLabel.font = UIFont(name: "Helvetica Bold", size: 25)
        tempLabel.font = UIFont(name: "Helvetica Bold", size: 50)
        
        currentLocation!.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            locationLabel.text = "\(city + ", " + country)"
        }
        
        if (tempSummary.contains(Main.clear)) {
            summaryLabel.text = "Солнечно"
        } else if (tempSummary.contains(Main.clouds)) {
            summaryLabel.text = "Облачно"
        } else if (tempSummary.contains(Main.rain)) {
            summaryLabel.text = "Дождь"
        } else if (tempSummary.contains(Main.snow)) {
            summaryLabel.text = "Снег"
        }
        
        tempLabel.text = "\(Int(self.currentWeather!.temp))°"
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return models.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: self.hourlyWeather)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            cell.configure(with: models[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

struct Root: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Current]
    let daily: [Daily]
}
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint: Double
    let uvi: Double?
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let pop: Double?
}
struct Weather: Codable {
    let id: Int
    let main: Main
    let weatherDescription: Description
    let icon: Icon
    enum CodingKeys: String, CodingKey {
        case id, main, weatherDescription = "description", icon
    }
}

struct Daily: Codable {
    let dt, sunrise, sunset: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let clouds: Int
    let pop: Double?
    let uvi: Double
}
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}
struct Temp: Codable {
    let day, min, max, night, eve, morn: Double
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
