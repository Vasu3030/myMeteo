//
//  CityViewModel.swift
//  weather
//
//  Created by AROUN Vassou on 28/09/2022.
//

import SwiftUI

class ForecastViewModel: ObservableObject{
    @Published var weather: Forecast?
    
    func weatherData(city: City) {

        let headers = [
            "X-RapidAPI-Key": "1d42eb1060msha3a265751d41db9p11954ejsn64a55bba78f3",
            "X-RapidAPI-Host": "dark-sky.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://dark-sky.p.rapidapi.com/\(city.latitude),\(city.longitude)?units=ca&lang=en")! as URL,
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
                let result = try newJSONDecoder().decode(Forecast.self, from: data!)
                DispatchQueue.main.async {
//                    print(result)
                    self.weather = result
                }
            } catch let error {
                print(error)
            }
        })

        dataTask.resume()
    }
    
    func windDirectionFromDegrees(degrees : Double) -> String {

        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i: Int = Int((degrees + 11.25)/22.5)
        return directions[i % 16]
    }
}
