//
//  CityViewModel.swift
//  weather
//
//  Created by AROUN Vassou on 28/09/2022.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

class CityViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var cities: [City] = []
    @Published var currentCity: City = City(id: -1, wikiDataId: "", name: "POPO", country: "", countryCode: "", region: "", regionCode: "", latitude: 0, longitude: 0, population: 0)
    @Published var myCities: [City] = []
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    

    override init() {
        super.init()
        manager.delegate = self
        self.myCities = getMyCities()
        requestLocation()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.first != nil {
            location.self = locations.first?.coordinate
            getCityByLocation(location: locations.first!.coordinate)
        }
        
    }
    
    func favCity(city: City) {

        self.myCities.append(city)
        
        if let encoded = try? JSONEncoder().encode(myCities) {
            UserDefaults.standard.set(encoded, forKey:"myCities")
        }
    }
    
    func delCity(city: City) {
        
        if let index = self.myCities.firstIndex(of: city) {
            self.myCities.remove(at: index)
        }
        if let encoded = try? JSONEncoder().encode(myCities) {
            UserDefaults.standard.set(encoded, forKey:"myCities")
        }
    }
    
    func getMyCities() -> [City] {
        
        if let data = UserDefaults.standard.object(forKey:"myCities") as? Data,
           let dataDecode = try? JSONDecoder().decode([City].self, from: data) {
            return dataDecode
        }
        
        return myCities
    }
    
    func getCurrentCity() -> City {
        
        return currentCity
    }
    
    func searchCity(city: String) -> [City] {
    
            
            let headers = [
                "X-RapidAPI-Key": "1d42eb1060msha3a265751d41db9p11954ejsn64a55bba78f3",
                "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
            ]
                        let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?limit=10&namePrefix=\(city)&sort=-population&types=CITY")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                do {
                    guard let httpResponse = response as? HTTPURLResponse,
                              (200...299).contains(httpResponse.statusCode) else {
                            // handle the error returned by a server
                            return
                    }
                    let result = try JSONDecoder().decode(ResponseCity.self, from: data!)
                    DispatchQueue.main.async {
                        self.cities = result.data
                    }
                } catch let error {
                    print(error)
                }
            })
            
            dataTask.resume()
        return self.cities
    }
    
    func getCityByLocation(location: CLLocationCoordinate2D) {
        
        let latitude: String = "\(String(location.latitude))"
        var longitude: String = "\(String(location.longitude))"
        
        if(location.longitude > 0){
            longitude = "%2B" + longitude
        }
        
        let headers = [
            "X-RapidAPI-Key": "1d42eb1060msha3a265751d41db9p11954ejsn64a55bba78f3",
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?location=\(latitude)\(longitude)&limit=1&sort=-population&types=CITY")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        // handle the error returned by a server
                        return
                }
                let result = try JSONDecoder().decode(ResponseCity.self, from: data!)
                DispatchQueue.main.sync {
                    self.currentCity = result.data[0]
                }
            } catch let error {
                print(error)
            }
        })

        dataTask.resume()
    }
}
