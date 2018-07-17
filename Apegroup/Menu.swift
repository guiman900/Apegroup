//
//  Menu.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 Menu model get from the network
 */
struct Menu
{
    // - MARK: properties
    
    /// Menu Id
    internal var id: Int
    
    /// Menu Category
    internal var category: String
    
    /// Menu name
    internal var name: String
    
    /// Menu topping
    internal var topping: [String]
    
    /// Menu Price
    internal var price: Double
    
    /// Menu Rank
    internal var rank: Int
}

extension Menu {
    // - MARK: Methods
    /**
     Constructor
     
     - Parameter json: json to unserialize and used to set the Menu model.
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
        
        guard let price = json["price"] as? Double else {
            throw SerializationError.missing("price")
        }
     
        
        self.id = id
        self.category = category
        self.name = name
        self.topping = []
        self.price = price
       
        
        if let topping = json["topping"] as? [String] {
            self.topping = topping
        }
        else {
            topping = []
        }
        
        if let rank = json["rank"] as? Int  {
            self.rank = rank
        }
        else
        {
            rank = 0
        }
    }
}
