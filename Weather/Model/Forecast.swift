// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let forecast = try? newJSONDecoder().decode(Forecast.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.forecastTask(with: url) { forecast, response, error in
//     if let forecast = forecast {
//       ...
//     }
//   }
//   task.resume()

import Foundation

enum Direction: String, CaseIterable {
    case n, nne, ne, ene, e, ese, se, sse, s, ssw, sw, wsw, w, wnw, nw, nnw
}

extension Direction: CustomStringConvertible  {
    init<D: BinaryFloatingPoint>(_ direction: D) {
        self =  Self.allCases[Int((direction.angle+11.25).truncatingRemainder(dividingBy: 360)/22.5)]
    }
    var description: String { rawValue.uppercased() }
}
extension BinaryFloatingPoint {
    var angle: Self {
        (truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
    }
    var direction: Direction { .init(self) }
}

// MARK: - Forecast
struct Forecast: Codable {
    let latitude, longitude: Double
    let timezone: String
    let currently: Currently
    let hourly: Hourly
    let daily: Daily
    let flags: Flags
    let offset: Double
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.currentlyTask(with: url) { currently, response, error in
//     if let currently = currently {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Currently
struct Currently: Codable, Hashable {
    let time: Int
    let summary: String
    let icon: String
    let precipIntensity, precipProbability: Double
    let precipType: String?
    let temperature, apparentTemperature, dewPoint, humidity: Double
    let pressure, windSpeed, windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility, ozone: Double
}

enum Icon: String, Codable {
    case cloudy = "cloudy"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case rain = "rain"
}

enum Summary: String, Codable {
    case mostlyCloudy = "Mostly Cloudy"
    case overcast = "Overcast"
    case partlyCloudy = "Partly Cloudy"
    case possibleDrizzle = "Possible Drizzle"
    case possibleLightRain = "Possible Light Rain"
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.dailyTask(with: url) { daily, response, error in
//     if let daily = daily {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Daily
struct Daily: Codable {
    let summary: String
    let icon: String
    let data: [Datum]
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.datumTask(with: url) { datum, response, error in
//     if let datum = datum {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Datum
struct Datum: Codable & Hashable {
    let time: Int
    let summary, icon: String
    let sunriseTime, sunsetTime: Int
    let moonPhase, precipIntensity, precipIntensityMax: Double
    let precipIntensityMaxTime: Int?
    let precipProbability: Double
    let precipType: String?
    let temperatureHigh: Double
    let temperatureHighTime: Int
    let temperatureLow: Double
    let temperatureLowTime: Int
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Int
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Int
    let dewPoint, humidity, pressure, windSpeed: Double
    let windGust: Double
    let windGustTime, windBearing: Int
    let cloudCover: Double
    let uvIndex, uvIndexTime: Int
    let visibility, ozone, temperatureMin: Double
    let temperatureMinTime: Int
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.flagsTask(with: url) { flags, response, error in
//     if let flags = flags {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Flags
struct Flags: Codable {
    let sources: [String]
    let meteoalarmLicense: String?
    let nearestStation: Double
    let units: String

    enum CodingKeys: String, CodingKey {
        case sources
        case meteoalarmLicense = "meteoalarm-license"
        case nearestStation = "nearest-station"
        case units
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.hourlyTask(with: url) { hourly, response, error in
//     if let hourly = hourly {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Hourly
struct Hourly: Codable {
    let summary: String
    let icon: String
    let data: [Currently]
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func forecastTask(with url: URL, completionHandler: @escaping (Forecast?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
