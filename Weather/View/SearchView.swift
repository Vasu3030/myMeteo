//
//  SearchView.swift
//  weather
//
//  Created by AROUN Vassou on 29/09/2022.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var ViewModel = CityViewModel()
    @State var searchingFor = ""
    @State var modify = false
    @State private var isPresented = false
    @Binding var tabSelection: Int
    @Binding var myCities : [City]
//    var locationManager = LocationViewManager()
    @State var currentCity: City
    
    var body: some View {
        HStack(){
            VStack {
                HStack{
                    Text("Weather")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    Button(action: {
                        if(modify){
                            modify = false
                        } else {
                            modify = true
                        }
                        
                    }) {
                        if (modify){
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.cyan)
                        } else {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(Color.cyan)
                        }
                    }
                }
                HStack{
                    SuperTextField(
                        placeholder: Text("Search city...")
                            .foregroundColor(.gray),
                        text: $searchingFor
                    ).foregroundColor(.white)
                        .padding(7)
                        .padding(.horizontal, 10)
                        .background(Color(white: 0.115))
                        .cornerRadius(8)
                }
                Spacer(minLength: 20)
                if(searchingFor != ""){
                    ScrollView{
                        ForEach(results, id: \.self) { city in
                            Button(action: {
                                isPresented.toggle()
                            }) {
                                HStack{
                                    Text(city.name)
                                    Text(city.country)
                                    Spacer()
                                }
                            }
                            .sheet(isPresented: $isPresented) {
                                CityDetailsModalView(searchingFor: $searchingFor, myCities: $myCities,city: city, tabSelection: $tabSelection)
                                    }
                            .padding()
                        }
                    }
                }
                else{
                    ScrollView{
                        HStack{
                            Button(action: {self.tabSelection = 1}) {
                                HStack{
                                    Text(currentCity.name)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Current Position")
                                        .foregroundColor(.white)
                                        .opacity(0.5)
                                    Spacer()
                                }
                            }
                            .padding()
                            Spacer()
                        }
                        .background(Color(white: 0.115))
                        ForEach(myCities, id: \.self) { city in
                            HStack{
                                Button(action: {self.tabSelection = city.id}) {
                                    HStack{
                                        Text(city.name)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Text(city.country)
                                            .foregroundColor(.white)
                                            .opacity(0.5)
                                        Spacer()
                                    }
                                }
                                .padding()
                                Spacer()
                                if(modify){
                                    Button(action: {
                                        ViewModel.delCity(city: city)
                                        if let index = myCities.firstIndex(of: city) {
                                            myCities.remove(at: index)
                                        }
                                    }) {
                                        HStack{
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .background(Color(white: 0.115))
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
    
    var results : [City] {
        if searchingFor.isEmpty{
            return []
        } else {
            return ViewModel.searchCity(city: searchingFor)
        }
    }
}


struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
    
}
