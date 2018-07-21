//
//  MasterViewController.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import UIKit
import CoreLocation

/**
 MasterViewController is used to display the restaurant list.
 */
class MasterViewController: UITableViewController {
    // - MARK: properties
    
    /// detail view controller displaying the restaurant menu.
    internal var detailViewController: DetailViewController? = nil
    
    /// list of restaurant to display
    internal var restaurants = [Restaurant]()
    
    /// location manager
    internal let locationManager = CLLocationManager()
    
    /// current location of the user
    internal var currentLocation: CLLocation?
    
    // - MARK: Methods
    /**
     Called after the controller's view is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(insertOrdersViewController(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.initCoreLocation()
        
        ApegroupNetwork.network.delegate = self
        ApegroupNetwork.network.getRestaurants()
    }

    /**
     Notifies the view controller that its view is about to be added to a view hierarchy.
     
     - Parameter animated: If true, the view is being added to the window using an animation.
    */
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    /**
     Sent to the view controller when the app receives a memory warning.
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    Shopping Bag
    */
    internal func insertOrdersViewController(_ sender: Any) {
        self.performSegue(withIdentifier: "OrdersPage", sender: self)
    }

}


/**
 UITableView Delegate
 */
extension MasterViewController {
    /**
     Asks the data source to verify that the given row is editable.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter indexPath: An index path locating a row in tableView.
     */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /**
     Asks the data source to commit the insertion or deletion of a specified row in the receiver.
     
     - Parameter tableView: The table-view object requesting the insertion or deletion.
     - Parameter editingStyle: The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath. Possible editing styles are insert or delete.
     - Parameter indexPath: An index path locating the row in tableView.
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            restaurants.remove(at: indexPath.section)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    /**
     Notifies the view controller that a segue is about to be performed.
 
     - Parameter segue: The segue object containing information about the view controllers involved in the segue.
     - Parameter sender: The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let restaurant = restaurants[indexPath.section]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                ApegroupNetwork.network.delegate = controller
                
                controller.restaurant = restaurant
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

/**
 UITableView Data Source
 */
extension MasterViewController {
    /**
     Asks the data source to return the number of sections in the table view.
     
     - Parameter tableView: An object representing the table view requesting this information.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.restaurants.count
    }
    
    /**
     Tells the data source to return the number of rows in a given section of a table view.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section in tableView.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count == 0 ? 0 : 1
    }
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     
     - Parameter tableView: A table-view object requesting the cell.
     - Parameter indexPath: An index path locating a row in tableView.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? GenericCell else {
            return UITableViewCell()
        }
        
        let restaurant = restaurants[indexPath.section]
        cell.name.text = restaurant.name
        cell.address.text = "\(restaurant.address1) \(restaurant.address2)"
        
        guard let currentLocation = currentLocation else {
            cell.distance.text = "?"
            return cell
        }
        
        let distance = restaurant.distance(to: currentLocation)
        cell.distance.text = distance >= 1000 ? String(format: "%.01f km", distance / 1000) : String(format: "%.0f m", distance)
        return cell
    }
    
    /**
     Asks the delegate for the height to use for the header of a particular section.
     This method allows the delegate to specify section headers with varying heights.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section of tableView .
     */
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    /**
     Asks the delegate for a view object to display in the header of the specified section of the table view.
     
     - Parameter tableView: The table-view object asking for the view object.
     - Parameter section: An index number identifying a section of tableView .
     */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

}

/**
Manage Core Location
 */
extension MasterViewController: CLLocationManagerDelegate {
    /**
     Init Core Location.
    */
    fileprivate func initCoreLocation() {
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    /**
     Tells the delegate that new location data is available. Implementation of this method is optional but recommended.
     
     - Parameter tableView: manager: The location manager object that generated the update event.
     - Parameter tableView: locations: An array of CLLocation objects containing the location data. This array always contains at least one object representing the current location. If updates were deferred or if multiple locations arrived before they could be delivered, the array may contain additional entries. The objects in the array are organized in the order in which they occurred. Therefore, the most recent location update is at the end of the array.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = manager.location else {
            return
        }
        
        if self.currentLocation == nil
        {
            self.refreshRestaurantDistanceWithNewList(userLocation: newLocation)

        } else {
            guard let distanceFromLastLocation = currentLocation?.distance(from: newLocation) else {
                return
            }
            if distanceFromLastLocation != 0
            {
                self.refreshRestaurantDistanceWithNewList(userLocation: newLocation)
            }
        }
    }
    
    /**
     Reorder the restaurant list
    */
    private func refreshRestaurantDistanceWithNewList(userLocation: CLLocation) {
        self.currentLocation =  userLocation

        guard let currentLocation = self.currentLocation else {
            return
        }
        self.restaurants.sort(by: { $0.distance(to: currentLocation) < $1.distance(to: currentLocation) })
        self.tableView.reloadData()
    }
}

/**
 Asynchronus delegate of the ApegroupNetworkProtocol
 */
extension MasterViewController : ApegroupNetworkProtocol {
    /**
     getRestaurants response
     
     - Parameter restaurants: restaurants list.
     */
    internal func restaurantsReceived(restaurants: [Restaurant])
    {
        if let currentLocation = currentLocation
        {
            self.restaurants = restaurants.sorted(by: { $0.distance(to: currentLocation) < $1.distance(to: currentLocation) })
        }
        else {
            self.restaurants = restaurants
        }
        tableView.reloadData()
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
    internal func orderReceived(order: Order)
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

