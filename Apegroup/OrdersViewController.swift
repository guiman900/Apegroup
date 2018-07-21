//
//  OrdersViewController.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 20/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

/**
 List of the previous orders.
 */
class OrdersViewController: UIViewController {
    // - MARK: properties
    /// Date converter string -> sate
    internal var dateFormatterGet = DateFormatter()
    
    /// Date converter date -> string
    internal var dateFormatterSet = DateFormatter()

    /// table view with the orders
    @IBOutlet weak var tableView: UITableView!
    
    // - MARK: Methods
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatterSet.dateFormat = "MM-dd-yyyy HH:mm"
    }
    
    /**
     Notifies the view controller that its view is about to be added to a view hierarchy.
     
     - Parameter animated: If true, the view is being added to the window using an animation.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    /**
     Sent to the view controller when the app receives a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Notifies the view controller that a segue is about to be performed.
     
     - Parameter segue: The segue object containing information about the view controllers involved in the segue.
     - Parameter sender: The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowOrderDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let order = OrderManager.orderManager.previousOrder[indexPath.section]
                let controller = segue.destination as? ResumeOrderViewController
                
                controller?.order = order
                controller?.title = order.restaurantName
                controller?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller?.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

/**
 UITableView Data Source
 */
extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    /**
     Tells the delegate that the specified row is now selected.
     - Parameter tableView: A table-view object informing the delegate about the new row selection.
     - Parameter indexPath: An index path locating the new selected row in tableView.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowOrderDetails", sender: self)
    }
    
    /**
     Asks the data source to return the number of sections in the table view.
     
     - Parameter tableView: An object representing the table view requesting this information.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return OrderManager.orderManager.previousOrder.count
    }
    
    /**
     Tells the data source to return the number of rows in a given section of a table view.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section in tableView.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderManager.orderManager.previousOrder.count == 0 ? 0 : 1
    }
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     
     - Parameter tableView: A table-view object requesting the cell.
     - Parameter indexPath: An index path locating a row in tableView.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? GenericCell else {
            return UITableViewCell()
        }
        
        let previousOrder = OrderManager.orderManager.previousOrder[indexPath.section]
        cell.name.text = previousOrder.restaurantName
        
        
        if let estimatedDelivery = previousOrder.esitmatedDelivery, let estimatedDeliveryDate = dateFormatterGet.date(from: estimatedDelivery)
        {
            cell.address.text = dateFormatterSet.string(from: estimatedDeliveryDate)
        }
        
        if let totalPrice = previousOrder.totalPrice {
            cell.distance.text = "\(totalPrice) $"
        }
        else {
            cell.distance.text = "? $"
        }
        
        cell.status.text = previousOrder.status
        
        return cell
    }
    
    /**
     Asks the delegate for the height to use for the header of a particular section.
     This method allows the delegate to specify section headers with varying heights.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section of tableView .
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    /**
     Asks the delegate for a view object to display in the header of the specified section of the table view.
     
     - Parameter tableView: The table-view object asking for the view object.
     - Parameter section: An index number identifying a section of tableView .
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}
