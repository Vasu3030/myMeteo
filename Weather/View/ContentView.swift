//
//  ContentView.swift
//  weather
//
//  Created by AROUN Vassou on 28/09/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var index = 1
    @State var myCities : [City]
    @State var currentCity: City
    
    init(myCities: [City], currentCity: City) {
        self.myCities = myCities
        self.currentCity = currentCity
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        TabView(selection: $index) {
            SearchView(tabSelection: $index, myCities: $myCities, currentCity: currentCity)
                .tag(0)
                .tabItem {
                    Label("searchCity", systemImage: "list.bullet")
                }
            CurrentCityView(currentCity: currentCity, tabSelection: $index)
                .tag(1)
                .tabItem {
                    Label("currentCity", systemImage: "location")
                }
                .navigationBarHidden(true)
            ForEach(myCities, id: \.self) { city in
                CityDetailsView(city: city, tabSelection: $index)
                    .tag(city.id)
                    .navigationBarHidden(true)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .padding()
        .background(Color.black)
    }
}
