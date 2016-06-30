//
//  HaversineCalculatorModel.swift
//  HaversineCalculator
//
//  Created by Andy on 21/06/2016.
//  Copyright © 2016 andywhale. All rights reserved.
//

import Foundation

class location {
    var name: String
    var longitude: Double
    var latitude: Double
    var longitudeSinHalf: Double?
    var latitudeSinHalf: Double?
    
    init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
    
    /**
     * These functions are added to our location for performance reasons to avoid duplication
     */
    func getLongitudeSinHalf() -> Double {
        if (self.longitudeSinHalf == nil) {
            self.longitudeSinHalf = sin(self.longitude / 2)
        }
        return self.longitudeSinHalf!
    }
    
    func getLatitudeSinHalf() -> Double {
        if (self.latitudeSinHalf == nil) {
            self.latitudeSinHalf = sin(self.latitude / 2)
        }
        return self.latitudeSinHalf!
    }
}

class HaversineApproximator {
    let kmToMiles: Double = 0.621371192
    
    func sphericalDistanceInMiles(locationFrom: location, locationTo: location) -> Double {
        return sphericalDistanceInKm(locationFrom, locationTo: locationTo) * self.kmToMiles
    }
    
    func sphericalDistanceInKm(locationFrom: location, locationTo: location) -> Double {
        let haversineFormulae = HaversineFormulae()
        return haversineFormulae.calculateSphericalDistance(locationFrom, locationTo: locationTo)
    }
}

class HaversineFormulae {
    let earthRadius: Double = 6371
    
    func calculateSphericalDistance(locationFrom: location, locationTo: location) -> Double {
        let locationDelta = calculateDeltaLocation(locationFrom, locationTo: locationTo)
        
        let a = locationDelta.getLatitudeSinHalf() * locationDelta.getLatitudeSinHalf() +
            cos(locationFrom.latitude * (M_PI / 180)) * cos(locationTo.latitude * (M_PI / 180)) *
            locationDelta.getLongitudeSinHalf() * locationDelta.getLongitudeSinHalf()
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        return self.earthRadius * c
    }
    
    func calculateDeltaLocation(locationFrom: location, locationTo: location) -> location {
        let deltaLatitude = (locationTo.latitude - locationFrom.latitude) * (M_PI / 180)
        let deltaLongitude = (locationTo.longitude - locationFrom.longitude) * (M_PI / 180)
        
        return location(name: "Delta", longitude: deltaLongitude, latitude: deltaLatitude)
    }
}

class HaversineApproximatorModel {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func calculateDistance() -> [String: Double] {
        let locationFrom = location(name: "Your Location", longitude: self.longitude, latitude: self.latitude)
        
        var distances = [String: Double]()
        
        var locations = [location]()
        
        locations.append(location(name: "Anglesey", longitude: -4.310578, latitude: 53.255694))
        locations.append(location(name: "Bristol", longitude: 2.5833, latitude: 51.4500))
        locations.append(location(name: "Leeds", longitude: -1.549077, latitude: 53.800755))
        locations.append(location(name: "London (Charing Cross)", longitude: -0.127758, latitude: 51.507351))
        locations.append(location(name: "New York", longitude: -74.005941, latitude: 40.712784))
        
        let distanceCalculator = HaversineApproximator()
        for location in locations {
            distances[location.name] = round(distanceCalculator.sphericalDistanceInMiles(locationFrom, locationTo: location) * 100) / 100
        }
        
        return distances
    }
}

//let approximator = HaversineApproximatorModel(latitude: 53.9583, longitude: 1.0803)
//approximator.calculateDistance()

