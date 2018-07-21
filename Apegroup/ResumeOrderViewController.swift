//
//  ResumeOrderViewController.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 20/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

/**
Review a created order
 */
class ResumeOrderViewController: UIViewController {
    // - MARK: properties
    
    /// order ordered date
    @IBOutlet weak var OrderedDate: UILabel!
    
    /// order delivery date
    @IBOutlet weak var DeliveredDate: UILabel!
    
    /// order total price
    @IBOutlet weak var Price: UILabel!
    
    /// order status
    @IBOutlet weak var Status: UILabel!
    
    /// order displayed
    var order: Order?
    
    /// Date converter string -> sate
    internal var dateFormatterGet = DateFormatter()
    
    /// Date converter date -> string
    internal var dateFormatterSet = DateFormatter()

    // - MARK: Methods
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApegroupNetwork.network.delegate = self
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatterSet.dateFormat = "MM-dd-yyyy HH:mm"
        
        self.configureLabels()
        if let order = self.order {
            ApegroupNetwork.network.getOrder(order: order)
        }
    }
    
    /**
     Configure the labels with the order object
    */
    fileprivate func configureLabels()
    {
        if let orderedAt = self.order?.orderedAt, let orderedDate = dateFormatterGet.date(from: orderedAt)
        {
            self.OrderedDate.text = dateFormatterSet.string(from: orderedDate)
        }
        
        if let estimatedDelivery = self.order?.esitmatedDelivery, let estimatedDeliveryDate = dateFormatterGet.date(from: estimatedDelivery)
        {
            self.DeliveredDate.text = dateFormatterSet.string(from: estimatedDeliveryDate)
        }
        
        
        if let totalPrice = self.order?.totalPrice {
            self.Price.text = "\(totalPrice) $"
        }
        else {
            self.Price.text = "? $"
        }
        
        self.Status.text = self.order?.status
    }
    
    /**
     Notifies the view controller that its view is about to be added to a view hierarchy.
     
     - Parameter animated: If true, the view is being added to the window using an
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    /**
     Sent to the view controller when the app receives a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

/**
 UITableView Data Source
 */
extension ResumeOrderViewController: UITableViewDataSource {
    
    /**
     Asks the data source to return the number of sections in the table view.
     
     - Parameter tableView: An object representing the table view requesting this information.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.order?.getMenu().count == 0 ? 0 : 1
    }
    
    /**
     Tells the data source to return the number of rows in a given section of a table view.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section in tableView.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = self.order?.getMenu().count
        {
            return rows
        }
        return 0
    }
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     
     - Parameter tableView: A table-view object requesting the cell.
     - Parameter indexPath: An index path locating a row in tableView.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = self.order?.getMenu()[indexPath.row]
        {
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
        return UITableViewCell()
    }
    
    /**
     Check if the menu hqve topping
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
    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
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
extension ResumeOrderViewController : ApegroupNetworkProtocol {
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
     create Order response
     
     - Parameter order: the order received from the server.
     */
    internal func orderCreated(order: Order)
    {
    }
    
    /**
     read Order response
     
     - Parameter order: the order received from the server.
     */
    func orderReceived(order: Order)
    {
        self.order?.updateOrder(order: order)
        self.configureLabels()
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
