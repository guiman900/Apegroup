//
//  Restaurant.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreLocation

public struct Restaurant {
    public var id: Int
    public var name: String
    public var address1: String
    public var address2: String
    public var latitude: CLLocationDegrees
    public var longitude: CLLocationDegrees
    
    var location: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}

extension Restaurant {
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
    }
}
