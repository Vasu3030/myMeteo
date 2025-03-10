//
//  SplashScreenView.swift
//  weather
//
//  Created by AROUN Vassou on 01/10/2022.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var color = Color(.black)
    @State private var background = Color(.white)
    @ObservedObject var ViewModel = CityViewModel()

    var body: some View{
        if isActive {
            ContentView(myCities: ViewModel.myCities, currentCity: ViewModel.currentCity)
                .preferredColorScheme(.dark)
        } else {
            VStack{
                VStack{
                    Image(systemName: "cloud.moon.bolt.fill")
                        .font(.system(size: 80))
                        .foregroundColor(color)
                }
                .scaleEffect(size)
                .opacity(opacity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(background)
            .onAppear{
                withAnimation(.easeIn(duration: 1.2)){
                    self.size = 2
                    self.opacity = 1.0
                    self.color = Color(.white)
                    self.background = Color(.black)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
    }
}
