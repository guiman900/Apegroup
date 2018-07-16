//
//  Category.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

public class Category
{
    var name: String
    var menu: [Menu]
    
    // - MARK: Methods
    /**
     Constructor
     
     - Parameter json: json to unserialize and used to set the Restaurant model.
     */
    init(json: [String: Any]?) throws {
        guard let json = json else {
            throw SerializationError.missing("json")
        }
        
        guard let categoryName = json["category"] as? String else {
            throw SerializationError.missing("category")
        }
        
        self.name = categoryName
        self.menu = []
        self.menu.append(try Menu(json: json))
    }

}

extension Category {
    
    static func createCategoryArray(json: [[String: Any]]) -> [Category]?
    {
        var result = [Category]()
        for case let networkMenu in json {
            do {
                if let category = result.first(where: { $0.name == networkMenu["category"] as? String}) {
                    category.menu.append(try Menu(json: networkMenu))
                }
                else {
                    result.append(try Category(json: networkMenu))
                }
            }
            catch {
                print("error")
            }
        }
        return result
    }
}
