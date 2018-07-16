//
//  Menu.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

struct Menu
{
    var id: Int
    var category: String
    var name: String
    var topping: [String]
    var price: Double
    var rank: Int
}

extension Menu {
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
        
        guard let category = json["category"] as? String else {
            throw SerializationError.missing("category")
        }
        
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        /**
        guard let topping = json["topping"] as? [String] else {
            throw SerializationError.missing("topping")
        }
        */
        guard let price = json["price"] as? Double else {
            throw SerializationError.missing("price")
        }
        guard let rank = json["rank"] as? Int else {
            throw SerializationError.missing("rank")
        }
        
        
        self.id = id
        self.category = category
        self.name = name
        self.topping = []
        self.price = price
        self.rank = rank
    }
}
