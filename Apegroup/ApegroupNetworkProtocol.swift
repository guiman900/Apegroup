//
//  ApegroupNetworkProtocol.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 ApegroupNetworkProtocol is used to retrieve the network results.
 */
public protocol ApegroupNetworkProtocol {
    // - MARK: Methods
    
    /**
     getRestaurants response
     
     - Parameter restaurants: restaurant list.
     */
    func restaurantsReceived(restaurants: [Restaurant])
    
    /**
     getMenu response
     
     - Parameter categories: categories with the menu.
     */
    func categoriesAndMenuReceived(categories: [Category])

    
    /**
     Method triggered if an error happend during one of the network operation
     
     - Parameter error: error description.
     */
    func networkError(error: String)
}
