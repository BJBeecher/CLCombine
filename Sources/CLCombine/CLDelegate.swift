//
//  File.swift
//  
//
//  Created by BJ Beecher on 7/15/21.
//

import Combine
import CoreLocation

final class CLDelegate : NSObject {
    
    let statusSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    let locationSubject = PassthroughSubject<[CLLocation], Error>()
    
}

// delegate conformance

extension CLDelegate : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationSubject.send(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubject.send(completion: .failure(error))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        statusSubject.send(manager.authorizationStatus)
    }
}
