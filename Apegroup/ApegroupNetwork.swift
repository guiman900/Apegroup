//
//  ApegroupNetwork.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import Alamofire

/**
 ApegroupNetwork is the network encapsulation for the Apegroup Rest APIs.
 */
public class ApegroupNetwork {
    // - Mark: Properties
    
    /// delegate to retrieve the network responses.
    public var delegate: ApegroupNetworkProtocol?
    
    /// static instance of ApegroupNetwork
    public static var network = ApegroupNetwork()
    
    // - Mark: Methods
    
    /**
     Constructor
     */
    public init() {}
    
    /**
     Get a list of restaurants.
     */
    public func getRestaurants()
    {
        guard let url = URL(string: Constants.GetRestaurants) else {
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil).validate()
            .responseJSON
            {
                response in
                
                guard let unWrappedDelegate = self.delegate else {
                    print("[getRestaurants]: ApegroupNetworkProtocol Delegate is nil")
                    return
                }
                
                guard response.result.isSuccess else {
                    unWrappedDelegate.networkError(error: String(describing: response.error?.localizedDescription))
                    return
                }
                
                var restaurants: [Restaurant] = []
                
                guard let json = response.result.value as? [[String: Any]] else
                {
                    unWrappedDelegate.networkError(error: "Unable to unserialize [getRestaurants] response")
                    return
                }
                
                for case let result in json {
                    if let restaurant = try? Restaurant(json: result) {
                        restaurants.append(restaurant)
                    }
                    else {
                        unWrappedDelegate.networkError(error: "Unable to convert [getRestaurants] json response into a Restaurants")
                    }
                }
                
                unWrappedDelegate.restaurantsReceived(restaurants: restaurants)
        }
    }
    
    /**
     Get the menu list of a Restaurant
     
     - Parameter restaurantId: Id of tehe restaurant.
     */
    public func getMenu(restaurantId: String)
    {
        guard let url = URL(string: "\(Constants.GetMenu)\(restaurantId)/menu") else {
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil).validate()
            .responseJSON
            {
                response in
                
                guard let unWrappedDelegate = self.delegate else {
                    print("[getMenu]: ApegroupNetworkProtocol Delegate is nil")
                    return
                }
                
                guard response.result.isSuccess else {
                    unWrappedDelegate.networkError(error: String(describing: response.error?.localizedDescription))
                    return
                }
                                
                guard let json = response.result.value as? [[String: Any]] else
                {
                    unWrappedDelegate.networkError(error: "Unable to unserialize [getMenu] response")
                    return
                }
                    if let categories = Category.createCategoryArray(json: json) {
                        unWrappedDelegate.categoriesAndMenuReceived(categories: categories)
                    }
                    else {
                        unWrappedDelegate.networkError(error: "Unable to convert [getMenu] json response into a categories and menus")
                    }
            }
    }
}
