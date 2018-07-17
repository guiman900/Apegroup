//
//  Category.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
Category Model, use to sort the menu before displaying it on the DetailViewController.
 */
public class Category
{
    // - MARK: properties
    
    /// Category Name
    internal var name: String
    
    /// menu list for this category
    internal var menu: [Menu]
    
    // - MARK: Methods
    /**
     Constructor
     
     - Parameter json: json to unserialize and used to set the Category model.
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
    /**
     Static func to create an array of menu sorted by categories.
     
     - Parameter json: json to unserialize and used to set the Category / Menu model.
     */

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
