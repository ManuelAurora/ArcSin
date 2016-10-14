//
//  LocationManager.swift
//  ArcSin
//
//  Created by Мануэль on 13.10.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import CoreLocation
import UIKit

class DeviceStatusIdentifier: NSObject, CLLocationManagerDelegate
{
    private let locationManager = CLLocationManager()
    
    let deviceVersion          = UIDevice.current.systemVersion
    let deviceModel            = UIDevice.current.model
    let screen                 = UIScreen.main.bounds
    let identifier             = UIDevice.current.identifierForVendor!.uuidString
    
    var location: CLLocation?
    
    func getCurrentLocation() {
        
        guard CLLocationManager.locationServicesEnabled() else { return }
        
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.distanceFilter  = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate        = self
        
        locationManager.startUpdatingLocation()
    }
    
    private func stopLocationManager() {
        
        locationManager.stopUpdatingLocation()
    }
    
    class func sharedInstance() -> DeviceStatusIdentifier {
        
        struct Singleton
        {
            static let dsi = DeviceStatusIdentifier()            
        }
        
        return Singleton.dsi
    }
    
    // MARK: Delegate functions
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        
        if newLocation.horizontalAccuracy < 0 { return } // Happens        
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy
        {
            location = newLocation
        }
        
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy
        {
            stopLocationManager()
        }
    }
    
}
