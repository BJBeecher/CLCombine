//
//  UserLocation.swift
//  Luna
//
//  Created by BJ Beecher on 8/23/20.
//  Copyright © 2020 Renaissance Technologies. All rights reserved.
//

import CoreLocation
import Combine

public final class CLClient {
    
    let manager : CLLocationManager
    let delegate : CLDelegate
    
    init(manager: CLLocationManager, delegate: CLDelegate){
        self.manager = manager
        self.delegate = delegate
    }
    
    public convenience init(desiredAccuracy accuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters, distanceFilter: CLLocationDistance = 1000) {
        let manager = CLLocationManager()
        let delegate = CLDelegate()
        
        manager.desiredAccuracy = accuracy
        manager.distanceFilter = distanceFilter
        manager.activityType = .other
        manager.delegate = delegate
        
        self.init(manager: manager, delegate: delegate)
    }
}

// computed

public extension CLClient {
    var authorizationStatus : CLAuthorizationStatus {
        manager.authorizationStatus
    }
}

// public API

public extension CLClient {
    func requestPermission() -> AnyPublisher<CLAuthorizationStatus, Never> {
        Deferred { [self] () -> AnyPublisher<CLAuthorizationStatus, Never> in
            manager.requestAlwaysAuthorization()
            
            return authorizationStatusPublisher()
                .first()
                .eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    func authorizationStatusPublisher() -> AnyPublisher<CLAuthorizationStatus, Never> {
        delegate.statusSubject
            .eraseToAnyPublisher()
    }
    
    func requestLocation() -> AnyPublisher<CLLocation, Error> {
        Deferred { [self] () -> AnyPublisher<CLLocation, Error> in
            manager.requestLocation()
            
            return delegate.locationSubject
                .first()
                .tryCompactMap(\.last)
                .eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    func startUpdatingLocation() -> AnyPublisher<[CLLocation], Error> {
        Deferred { [self] () -> AnyPublisher<[CLLocation], Error> in
            manager.startUpdatingLocation()
            
            return delegate
                .locationSubject
                .eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
