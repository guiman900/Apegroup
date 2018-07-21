//
//  DetailViewController.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import UIKit

/**
Detail View Controller to manage an order. 
*/
class DetailViewController: UIViewController {
    // - MARK: properties

    /// table view
    @IBOutlet weak var tableView: UITableView!
    
    /// restaurant selected
    internal var restaurant: Restaurant? {
        didSet {
            self.title = restaurant?.name
        }
    }
    
    // - MARK: Methods

    /**
     update the view
    */
    fileprivate func configureView() {
        // Update the user interface for the detail item.
        if let count = restaurant?.categories?.count, count > 0 {
            if tableView == nil {
                self.tableView =   UITableView()
            }
            tableView.reloadData()

        }
    }

    /**
     Called after the controller's view is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let addButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(OrderViewController(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        if restaurant?.categories?.count == 0, let id = restaurant?.id {
            ApegroupNetwork.network.getMenu(restaurantId: String(id))
        }
        else {
            // reset order and data
            configureView()
        }
    }

    /**
     Notifies the view controller that its view is about to be added to a view hierarchy.
     
     - Parameter animated: If true, the view is being added to the window using an
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    /**
     Sent to the view controller when the app receives a memory warning.
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     perform the segue to navigate to the order page.
    */
    internal func OrderViewController(_ sender: Any) {
        self.performSegue(withIdentifier: "OrderPage", sender: self)
    }
    
    /**
     Reset the menu restaurant quantity
    */
    internal func resetMenu(){
        self.restaurant?.resetMenuQuantities()
    }
}

/**
 UITableView Data Source
 */
extension DetailViewController: UITableViewDataSource {
    
    /**
     Asks the data source for the title of the header of the specified section of the table view.
    
     - Parameter tableView: The table-view object asking for the title.
     - Parameter section: An index number identifying a section of tableView .
     
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title =  self.restaurant?.categories?[section].name
        return title
    }
    
    /**
     Asks the data source to return the number of sections in the table view.
     
     - Parameter tableView: An object representing the table view requesting this information.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let result = self.restaurant?.categories?.count else
        {
            return 0
        }
        return result
    }
    
    /**
     Tells the data source to return the number of rows in a given section of a table view.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section in tableView.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = self.restaurant?.categories?[section].menu.count else
        {
            return 0
        }
        return result
    }
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     
     - Parameter tableView: A table-view object requesting the cell.
     - Parameter indexPath: An index path locating a row in tableView.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menu = self.restaurant?.categories?[indexPath.section].menu[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: doesTheMenuHaveTopping(count: menu?.topping.count) ? "MenuCell" : "MenuNoToppingCell", for: indexPath) as? MenuCell else {
                return UITableViewCell()
        }
        
        cell.name.text = menu?.name
        if let price = menu?.price {
            cell.price.text = "\(price) $"
        }
        else {
            cell.price.text = "NA"

        }
        
        if doesTheMenuHaveTopping(count: menu?.topping.count) {
            cell.topping.text = menu?.topping.joined(separator: ", ")
        }
        
        if menu?.category.lowercased() == "pizza" {
            cell.menuImage.image = UIImage(named: "pizza_icon_iphone")
        }
        else if menu?.category.lowercased() == "dryck" {
            cell.menuImage.image = UIImage(named: "can_iphone")
        }
        else {
            cell.menuImage.image = UIImage(named: "dish_iphone")
        }
        
        if let quantity = menu?.quantity {
            cell.quantity.text = "\(quantity)"
        }
        else {
            cell.quantity.text = "0"
            
        }
        
        return cell
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
Button management
*/
extension DetailViewController {
    /**
     Add a menu to the order
    */
    @IBAction func addButton(_ sender: Any) {
        if let cell = (sender as? UIButton)?.superview?.superview as? UITableViewCell
        {
            if let indexPath = self.tableView.indexPath(for: cell) {
                if let menu = self.restaurant?.categories?[indexPath.section].menu[indexPath.row], menu.quantity < 10 {
                    OrderManager.orderManager.addMenu(restaurant: self.restaurant, menu: menu)
                    self.restaurant?.categories?[indexPath.section].menu[indexPath.row].quantity += 1
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    /**
     Remove a menu from the order
    */
    @IBAction func removeButton(_ sender: Any) {
        if let cell = (sender as? UIButton)?.superview?.superview as? UITableViewCell
        {
            if let indexPath = self.tableView.indexPath(for: cell) {
                if let menu = self.restaurant?.categories?[indexPath.section].menu[indexPath.row], menu.quantity > 0 {
                    OrderManager.orderManager.removeMenu(restaurant: self.restaurant, menu: menu)
                    self.restaurant?.categories?[indexPath.section].menu[indexPath.row].quantity -= 1
                    self.tableView.reloadData()
                }
            }
            
        }
    }
}

/**
 Asynchronus delegate of the ApegroupNetworkProtocol
 */
extension DetailViewController : ApegroupNetworkProtocol {
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
        self.restaurant?.categories = categories
        self.configureView()
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
