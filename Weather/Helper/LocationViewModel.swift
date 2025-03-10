////
////  LocationViewModel.swift
////  weather
////
////  Created by AROUN Vassou on 29/09/2022.
////
//
//import CoreLocation
//import CoreLocationUI
//
//class LocationViewManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    let manager = CLLocationManager()
//    
//    @Published var location: CLLocationCoordinate2D?
//    
//    override init() {
//        super.init()
//        manager.delegate = self
//        requestLocation()
//    }
//    
//    func requestLocation() {
//        manager.requestLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("error:: \(error.localizedDescription)")
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//    
//        if status == .authorizedWhenInUse {
//            manager.requestLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        if locations.first != nil {
//            location.self = locations.first?.coordinate
//        }
//        
//    }
//}
