//
//  CityDetailsView.swift
//  weather
//
//  Created by AROUN Vassou on 30/09/2022.
//

import Foundation
import _CoreLocationUI_SwiftUI
import SwiftUI

struct CityDetailsView: View{
    @State var city: City
    @State var CtoF: Double = 0
    @State var fahrenheit = false
    @State var labelCtoF = "C°"
    @Binding var tabSelection: Int
    @ObservedObject var ForecastVM = ForecastViewModel()
    
    init(city: City, tabSelection: Binding<Int>, ForecastVM: ForecastViewModel = ForecastViewModel()) {
        self._tabSelection = tabSelection
        self.city = city
        self.ForecastVM = ForecastVM
        
        ForecastVM.weatherData(city: self.city)
    }
    
    func getHour(timezone: String, timestamp: Int, identifier: String) -> String {
        let codeIdentifier = identifier.lowercased() + "_" + identifier
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = TimeZone(identifier: timezone)!
        let date = NSDate(timeIntervalSince1970: TimeInterval(timestamp))
        
        dateFormatter.locale = Locale(identifier: codeIdentifier)
        return dateFormatter.string(from: date as Date)
    }
    
    func getDay(timestamp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "E"
        let date = NSDate(timeIntervalSince1970: TimeInterval(timestamp))
        
        dateFormatter.locale = Locale(identifier: "us_US")
        return dateFormatter.string(from: date as Date).capitalized
    }
    
    var body: some View{
        if let forecast = forecastData {
            ScrollView(showsIndicators: false){
                VStack(spacing: 10){
                    HStack(){
                        Button(action: {
                            if(!fahrenheit){
                                fahrenheit = true
                                labelCtoF = "F°"
                            } else {
                                fahrenheit = false
                                labelCtoF = "C°"
                            }
                        }) {
                            Text(self.labelCtoF)
                                .foregroundColor(Color.cyan)
                        }
                        .padding()
                        Spacer()
                        Button(action: {self.tabSelection = 0}) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.cyan)
                        }
                        .padding()
                    }
                    VStack{
                        Text(city.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        if(fahrenheit){
                            Text("\((round(forecast.currently.temperature) * 9/5 + 32), specifier: "%.0f")°")
                                .font(.system(size: 80))
                        } else {
                            Text("\(forecast.currently.temperature, specifier: "%.0f")°")
                                .font(.system(size: 80))
                        }
                        Text(forecast.currently.summary)
                            .opacity(0.5)
                        HStack{
                            if(fahrenheit){
                                Text("Min.\((round(forecast.daily.data[0].temperatureMin) * 9/5 + 32), specifier: "%.0f")°")
                            } else {
                                Text("Min.\(forecast.daily.data[0].temperatureMin, specifier: "%.0f")°")
                            }
                            if(fahrenheit){
                                Text("Max.\((round(forecast.daily.data[0].temperatureMax) * 9/5 + 32), specifier: "%.0f")°")
                            } else {
                                Text("Max.\(forecast.daily.data[0].temperatureMax, specifier: "%.0f")°")
                            }
                        }
                        HStack{
                            Image(systemName: "sunrise")
                            Text(getHour(timezone: forecast.timezone, timestamp: forecast.daily.data[0].sunriseTime, identifier: city.countryCode) + "h")
                            Spacer()
                            Image(systemName: "sunset")
                            Text(getHour(timezone: forecast.timezone, timestamp: forecast.daily.data[0].sunsetTime, identifier: city.countryCode) + "h")
                        }
                        Spacer(minLength: 30)
                    }
                    VStack{
                        HStack{
                            Text("Forecast of the next 24 hours")
                                .opacity(0.5)
                            Spacer()
                        }
                        Divider()
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                VStack(spacing: 10){
                                    Text("Now.")
                                    Image(forecast.hourly.data[0].icon)
                                        .resizable()
                                        .scaledToFit()
                                    if(fahrenheit){
                                        Text("\((round(forecast.currently.temperature) * 9/5 + 32), specifier: "%.0f")°")
                                    } else {
                                        Text("\(forecast.currently.temperature, specifier: "%.0f")°")
                                    }
                                }
                                ForEach(forecast.hourly.data[1..<25], id: \.self) { hourly in
                                    VStack(spacing: 10){
                                        Text(getHour(timezone: forecast.timezone, timestamp: hourly.time, identifier: city.countryCode) + "h")
                                        Image(hourly.icon)
                                            .resizable()
                                            .scaledToFit()
                                        if(fahrenheit){
                                            Text("\((round(hourly.temperature) * 9/5 + 32), specifier: "%.0f")°")
                                        } else {
                                            Text("\(hourly.temperature, specifier: "%.0f")°")
                                        }
                                    }
                                }
                            }
                            .frame(minHeight: 0, maxHeight: .greatestFiniteMagnitude)
                        }
                        .frame(height: 100)
                    }
                    .padding()
                    .background(Color(white: 0.115))
                    VStack{
                        HStack{
                            Text("Forecast of the next 7 days")
                                .opacity(0.5)
                            Spacer()
                        }
                        Divider()
                        VStack{
                            HStack{
                                Text("Tod.")
                                    .frame(width: 50)
                                Image(forecast.daily.data[0].icon)
                                    .resizable()
                                    .scaledToFit()
                                if(fahrenheit){
                                    Text("Min.\((round(forecast.daily.data[0].temperatureMin) * 9/5 + 32), specifier: "%.0f")°")
                                } else {
                                    Text("Min.\(forecast.daily.data[0].temperatureMin, specifier: "%.0f")°")
                                }
                                Spacer()
                                if(fahrenheit){
                                    Text("Max.\((round(forecast.daily.data[0].temperatureMax) * 9/5 + 32), specifier: "%.0f")°")
                                } else {
                                    Text("Max.\(forecast.daily.data[0].temperatureMax, specifier: "%.0f")°")
                                }
                            }
                            .frame(height: 35)
                            ForEach(forecast.daily.data[1..<8], id: \.self) { daily in
                                HStack{
                                    Text(getDay(timestamp: daily.time) + ".")
                                        .frame(width: 50)
                                    Image(daily.icon)
                                        .resizable()
                                        .scaledToFit()
                                    if(fahrenheit){
                                        Text("Min.\((round(daily.temperatureMin) * 9/5 + 32), specifier: "%.0f")°")
                                    } else {
                                        Text("Min.\(daily.temperatureMin, specifier: "%.0f")°")
                                    }
                                    Spacer()
                                    if(fahrenheit){
                                        Text("Max.\((round(daily.temperatureMax) * 9/5 + 32), specifier: "%.0f")°")
                                    } else {
                                        Text("Max.\(daily.temperatureMax, specifier: "%.0f")°")
                                    }
                                }
                                .frame(height: 35)
                            }
                        }
                    }
                    .padding()
                    .background(Color(white: 0.115))
                    HStack(){
                        VStack{
                            HStack{
                                Image(systemName: "thermometer")
                                Text("Humidity")
                                Spacer()
                            }
                            .opacity(0.5)
                            Spacer()
                            HStack{
                                Text("\(forecast.currently.humidity * 100, specifier: "%.0f")%")
                                Spacer()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.115))
                        Spacer()
                        VStack{
                            HStack{
                                Image(systemName: "gauge")
                                Text("Pressure")
                                Spacer()
                            }
                            .opacity(0.5)
                            Spacer()
                            HStack{
                                Text("\(forecast.currently.pressure, specifier: "%.0f")hPa")
                                Spacer()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.115))
                    }
                    HStack(){
                        VStack{
                            HStack{
                                Image(systemName: "wind")
                                Text("Wind")
                                Spacer()
                            }
                            .opacity(0.5)
                            Spacer()
                            HStack{
                                Text("Speed")
                                Spacer()
                                Text("\(forecast.currently.windSpeed, specifier: "%.0f")km/h")
                            }
                            HStack{
                                Text("From")
                                Spacer()
                                Text(ForecastVM.windDirectionFromDegrees(degrees: Double(forecast.currently.windBearing)))
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.115))
                        Spacer()
                        VStack{
                            HStack{
                                Image(systemName: "eye")
                                Text("Visibility")
                                Spacer()
                            }
                            .opacity(0.5)
                            Spacer()
                            HStack{
                                Text("\(forecast.currently.visibility, specifier: "%.0f")km")
                                Spacer()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.115))
                    }
                }
                .padding()
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
        }
    }
    
    var forecastData : Forecast? {
        return ForecastVM.weather
    }
}
