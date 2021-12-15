//
//  File.swift
//  
//
//  Created by BJ Beecher on 7/15/21.
//

import Foundation

enum CLError : Error {
    case unknownError(_ error: Error)
    case coordinateNotFound
    case noLastLocation
    case geocodingError
    case accessDenied
}
