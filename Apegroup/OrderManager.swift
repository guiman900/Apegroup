//
//  OrderManager.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 17/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 Manager for the user order.
 */
internal class OrderManager
{
    // - MARK: properties
    
    /// Singleton instance of the order manager
    internal static var orderManager = OrderManager()
    
    /// current order
    internal var currentOrder =  Order()
    
    /// previous orders made by the user
    internal var previousOrder: [Order] = []
    
     // - MARK: Methods
    /**
     Add a menu from the current order
     
     - Parameter restaurant: restaurant where the menu comes from.
     - Parameter menu: new menu to add
     */
    internal func addMenu(restaurant: Restaurant?, menu: Menu)
    {
        if self.currentOrder.restaurantId == nil {
            self.currentOrder.restaurantId = restaurant?.id
            self.currentOrder.restaurantName = restaurant?.name
            self.currentOrder.resetMenu()
        }
        
        if restaurant?.id != self.currentOrder.restaurantId {
            self.currentOrder.restaurantId = restaurant?.id
            self.currentOrder.restaurantName = restaurant?.name
            self.currentOrder.resetMenu()
        }
        currentOrder.addMenu(newMenu: menu)
    }
    
    /**
     Remove a menu from the current order
     
     - Parameter restaurant: restaurant where the menu comes from.
     - Parameter menu: menu to remove
     */
    internal func removeMenu(restaurant: Restaurant?, menu: Menu)
    {
        if self.currentOrder.restaurantId == nil {
            self.currentOrder.restaurantId = restaurant?.id
            self.currentOrder.restaurantName = restaurant?.name
        }
        
        if restaurant?.id != self.currentOrder.restaurantId {
            self.currentOrder.restaurantId = restaurant?.id
            self.currentOrder.restaurantName = restaurant?.name
            self.currentOrder.resetMenu()
        }
        currentOrder.removeMenu(oldMenu: menu)
    }
    
    /**
     Get a serialization of the order. (used to create an order)
     */
    internal func getOrderSerialized() -> [String: Any]
    {
        var result: [String: Any] = Dictionary<String, Any>()
        result["restuarantId"] = self.currentOrder.restaurantId
        result["cart"] = self.currentOrder.getMenuListSerialized()
        return result
    }
    
    /**
     Add the current order to the previous order list and reset the current order.
    */
    internal func currentOrderFinished()
    {
        self.previousOrder.append(self.currentOrder.copy())
        self.currentOrder.resetOrder()
    }
    
    /**
     Update the current order with a new order. (results get from ReadOrder)
     
     - Parameter order: new order values.
     */
    internal func updateExistingOrder(order: Order)
    {
        if let existingOrder = self.previousOrder.first(where: { $0.orderId == order.orderId}) {
            existingOrder.updateOrder(order: order)
        }
    }
  
}
