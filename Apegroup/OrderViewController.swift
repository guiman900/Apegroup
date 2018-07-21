//
//  OrderViewController.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 18/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

/**
 Review the order before sending it to the server
 */
class OrderViewController: UIViewController {
    // - MARK: Methods

    /**
     Called after the controller's view is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Order"
        
        ApegroupNetwork.network.delegate = self
    }
    
    /**
     Sent to the view controller when the app receives a memory warning
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Send the order to the server.
    */
    @IBAction func completeOrder(_ sender: Any) {
        if OrderManager.orderManager.currentOrder.getMenu().count > 0 {
        ApegroupNetwork.network.createOrder(orderManager: OrderManager.orderManager)
        }
        else {
            let alert = UIAlertController(title: "ERROR", message: "You need to add products to your bag to be able to do an order.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

/**
 UITableView Data Source
 */
extension OrderViewController: UITableViewDataSource {
    
    /**
     Asks the data source for the title of the header of the specified section of the table view.
    
     - Parameter tableView: The table-view object asking for the title.
     - Parameter section: An index number identifying a section of tableView .
    */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let price = OrderManager.orderManager.currentOrder.calculateTotalPrice()
        if let restaurantName = OrderManager.orderManager.currentOrder.restaurantName {
            return "\(restaurantName) - \(price)$"
        }
        return ""
    }

    
    /**
     Asks the data source to return the number of sections in the table view.
     
     - Parameter tableView: An object representing the table view requesting this information.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return OrderManager.orderManager.currentOrder.getMenu().count == 0 ? 0 : 1
    }
    
    /**
     Tells the data source to return the number of rows in a given section of a table view.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section in tableView.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderManager.orderManager.currentOrder.getMenu().count
    }
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     
     - Parameter tableView: A table-view object requesting the cell.
     - Parameter indexPath: An index path locating a row in tableView.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menu = OrderManager.orderManager.currentOrder.getMenu()[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: doesTheMenuHaveTopping(count: menu.topping.count) ? "MenuCell" : "MenuNoToppingCell", for: indexPath) as? MenuCell else {
            return UITableViewCell()
        }
        
        cell.name.text = menu.name
        cell.price.text = "\(menu.price) $"
        
        if doesTheMenuHaveTopping(count: menu.topping.count) {
            cell.topping.text = menu.topping.joined(separator: ", ")
        }
        
        if menu.category.lowercased() == "pizza" {
            cell.menuImage.image = UIImage(named: "pizza_icon_iphone")
        }
        else if menu.category.lowercased() == "dryck" {
            cell.menuImage.image = UIImage(named: "can_iphone")
        }
        else {
            cell.menuImage.image = UIImage(named: "dish_iphone")
        }
        
        cell.quantity.text = "\(menu.quantity)"
        
        return cell
    }
    
    /**
     calculate if there is any topping on the menu Item

     - Parameter count: The number of topping
     */
    private func doesTheMenuHaveTopping(count: Int?) -> Bool
    {
        if let number = count, number > 0
        {
            return true
        }
        return false
    }
    
    /**
     Asks the delegate for the height to use for the header of a particular section.
     This method allows the delegate to specify section headers with varying heights.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section of tableView .
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            tableViewHeaderFooterView.contentView.backgroundColor = UIColor(red: 19 / 255, green: 105 / 255, blue: 128 / 255, alpha: 1)
            tableViewHeaderFooterView.textLabel?.textColor = UIColor.white
        }
    }
}

/**
 Asynchronus delegate of the ApegroupNetworkProtocol
 */
extension OrderViewController : ApegroupNetworkProtocol {
    /**
     getRestaurants response
     
     - Parameter restaurants: restaurants list.
     */
    internal func restaurantsReceived(restaurants: [Restaurant])
    {
    }
    
    /**
     getMenu response
     
     - Parameter categories: categories with the menu.
     */
    internal func categoriesAndMenuReceived(categories: [Category])
    {
    }
    
    /**
     read Order response
     
     - Parameter order: the order received from the server.
     */
    func orderReceived(order: Order)
    {
        
    }
    
    /**
     create Order response
     
     - Parameter order: the order received from the server.
     */
    internal func orderCreated(order: Order)
    {        
        OrderManager.orderManager.currentOrderFinished()
        (navigationController?.viewControllers[0] as? DetailViewController)?.resetMenu() 
        
        let alert = UIAlertController(title: "SUCCESS", message: "Your order has been received.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    
    /**
     Method triggered if an error happend during one of the network operation
     
     - Parameter error: error description.
     */
    internal func networkError(error: String)
    {
        print(error)
    }
}
