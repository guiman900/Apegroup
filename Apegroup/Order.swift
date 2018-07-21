//
//  Order.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 17/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 Order Class
 */
internal class Order {
    // - MARK: properties
    
    /// restaurant id
    internal var restaurantId: Int?
    
    /// restaurant name
    internal var restaurantName: String?
    
    /// order Id
    internal var orderId: Int?
    
    /// order total price
    internal var totalPrice: Double?
    
    /// order ordered at
    internal var orderedAt: String?
    
    /// estimated time delivery
    internal var esitmatedDelivery: String?
    
    /// order status
    internal var status: String?
    
    /// order menu
    fileprivate var menu: [Menu] = []

    // - MARK: Methods
    /**
     Constructor
     */
    init(json: [String: Any]?) throws {
       try self.setOrderWithJson(json: json)
    }
    
    /**
     Constructor
     */
    init(){
    }

    
    /**
     Init order with json dictionnary. Does not init the menu array.
     
    - Parameter json: json dictionnary
     */
    internal func setOrderWithJson(json: [String: Any]?) throws
    {
        guard let json = json else {
            throw SerializationError.missing("json")
        }
        
        guard let orderId = json["orderId"] as? Int else {
            throw SerializationError.missing("orderId")
        }
        
        guard let totalPrice = json["totalPrice"] as? Double else {
            throw SerializationError.missing("totalPrice")
        }
        
        guard let orderedAt = json["orderedAt"] as? String else {
            throw SerializationError.missing("orderedAt")
        }
        
        
        guard let esitmatedDelivery = json["esitmatedDelivery"] as? String else {
            throw SerializationError.missing("esitmatedDelivery")
        }
        
        guard let status = json["status"] as? String else {
            throw SerializationError.missing("status")
        }
        
        
        self.orderId = orderId
        self.totalPrice = totalPrice
        self.orderedAt = orderedAt
        self.esitmatedDelivery = esitmatedDelivery
        self.status = status
        
        // No need to unserialize the menu. Already available on the code.
    }
    
    /**
     Update order values. (does not set the menu)
     
     - Parameter order: new order values
    */
    internal func updateOrder(order: Order)
    {
        self.totalPrice = order.totalPrice
        self.orderedAt = order.orderedAt
        self.esitmatedDelivery = order.esitmatedDelivery
        self.status = order.status
    }
    
    /**
     Add a menu to the order
     
     - Parameter newMenu : menu to add
    */
    internal func addMenu(newMenu: Menu)
    {
        if newMenu.quantity < 10 {
            if let existingMenuIndex = self.menu.index(where: { $0.id == newMenu.id}) {
                self.menu[existingMenuIndex].quantity += 1
            }
            else {
                var insertedMenu = newMenu
                insertedMenu.quantity += 1
                self.menu.append(insertedMenu)
            }
        }
    }
    
    /**
     remove a menu to the order
     
     - Parameter oldMenu : remove menu
     */
    internal func removeMenu(oldMenu: Menu)
    {
        if let existingMenuIndex = self.menu.index(where: { $0.id == oldMenu.id}) {
            if self.menu[existingMenuIndex].quantity <= 1
            {
                self.menu[existingMenuIndex].quantity -= 1
                if let index = self.menu.index(where: { $0.id == oldMenu.id}) {
                    self.menu.remove(at: index)
                }
            }
            else {
                self.menu[existingMenuIndex].quantity -= 1
            }
        }
    }

    /**
     Get the menu order
    */
    internal func getMenu() -> [Menu]
    {
        return self.menu
    }
    
    
    /**
     Reset menu array
    */
    internal func resetMenu()
    {
        self.menu = []
    }
    
    /**
     reset the order
     */
    internal func resetOrder()
    {
        self.orderId = nil
        self.totalPrice = nil
        self.orderedAt = nil
        self.esitmatedDelivery = nil
        self.status = nil

        self.resetMenu()
    }
    
    /**
     Get a serialized version of the order (used to create an order)
    */
    internal func getMenuListSerialized() -> [[String: Any]]
    {
        var result: [[String: Any]] = [[String: Any]]()
        for menuItem in self.menu {
            var newItem = [String: Any]()
            newItem["menuItemId"] = menuItem.id
            newItem["quantity"] = menuItem.quantity
            result.append(newItem)
        }
        return result
    }

    /**
     Create a copy of the order
    */
    internal func copy() -> Order {
        let newOrder = Order()
        newOrder.restaurantId = self.restaurantId
        newOrder.restaurantName = self.restaurantName
        newOrder.orderId = self.orderId
        newOrder.totalPrice = self.totalPrice
        newOrder.orderedAt = self.orderedAt
        newOrder.esitmatedDelivery = self.esitmatedDelivery
        newOrder.status = self.status

        newOrder.menu = self.menu

        return newOrder
    }
    
    /**
     Calculate the total price of the order
     */
    internal func calculateTotalPrice() -> Double
    {
            var total: Double = 0.0
            for menuItem in menu {
                total += (menuItem.price * Double(menuItem.quantity))
            }
            return total
    }
}
