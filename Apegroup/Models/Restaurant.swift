//
//  Restaurant.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreLocation


/**
 Restaurant model get from the network.
 */
public class Restaurant {
    // - Mark: Properties
    
    /// Restaurant Id
    internal var id: Int
    
    /// Restaurant name
    internal var name: String
    
    /// Restaurant address (Street and Number)
    internal var address1: String
    
    /// Restaurant address (Zip Code and City)
    internal var address2: String
    
    /// Restaurant Latitude
    internal var latitude: CLLocationDegrees
    
    /// Restaurant Longitude
    internal var longitude: CLLocationDegrees
    
    /// Restaurant Category list containing the menus.
    internal var categories: [Category]?
    
    /// Restaurant Location
    internal var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    // - MARK: Methods
    /**
     Constructor
     
     - Parameter json: json to unserialize and used to set the Restaurant model.
     */
    init(json: [String: Any]?) throws {
        guard let json = json else {
            throw SerializationError.missing("json")
        }
        
        print(json)
        guard let id = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }
        
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        guard let address1 = json["address1"] as? String else {
            throw SerializationError.missing("address1")
        }
        
        
        guard let address2 = json["address2"] as? String else {
            throw SerializationError.missing("address2")
        }
        
        guard let latitude = json["latitude"] as? Double else {
            throw SerializationError.missing("latitude")
        }
        
        guard let longitude = json["longitude"] as? Double else {
            throw SerializationError.missing("longitude")
        }
        
        
        self.id = id
        self.name = name
        self.address1 = address1
        self.address2 = address2
        self.latitude = latitude
        self.longitude = longitude
        
        self.categories = []
    }

    /**
     Restaurant distance from the current location parameter

     - Parameter location: location of the user.
     */
    internal func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}
