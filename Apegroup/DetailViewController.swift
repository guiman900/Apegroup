//
//  DetailViewController.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    internal var restaurant: Restaurant? {
        didSet {
            self.title = restaurant?.name
        }
    }

    fileprivate func configureView() {
        // Update the user interface for the detail item.
        if let count = restaurant?.categories?.count, count > 0 {
            if tableView == nil {
                self.tableView =   UITableView()
            }
            tableView.reloadData()

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if restaurant?.categories?.count == 0, let id = restaurant?.id {
            ApegroupNetwork.network.getMenu(restaurantId: String(id))
        }
        else {
            configureView()
        }
//       UINavigationBar.appearance().backgroundColor = UIColor(red: 19 / 255, green: 105 / 255, blue: 128 / 255, alpha: 1)
//        UITabBar.appearance().backgroundColor = UIColor.yellow
//        UINavigationBar.appearance().barTintColor = UIColor(red: 46.0/255.0, green: 14.0/255.0, blue: 74.0/255.0, alpha: 1.0)
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
//        
//        self.preferredStatusBarStyle =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

/**
 UITableView Data Source
 */
extension DetailViewController: UITableViewDataSource {
    
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
        
        return cell
    }
    
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
extension DetailViewController : ApegroupNetworkProtocol {
    /**
     getRestaurants response
     
     - Parameter restaurants: restaurants list.
     */
    internal func restaurantsReceived(restaurants: [Restaurant])
    {
        print(restaurants)
    }
    
    internal func categoriesAndMenuReceived(categories: [Category])
    {
        self.restaurant?.categories = categories
        self.configureView()
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
