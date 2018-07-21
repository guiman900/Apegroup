//
//  RestaurantCell.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

/**
 TableViewCell used on the MasterViewController
 */
internal class GenericCell: UITableViewCell {
    // - MARK: properties
    
    /// Restaurant name.
    @IBOutlet weak var name: UILabel!
    
    /// Restaurant Address / Order delivery time
    @IBOutlet weak var address: UILabel!
    
    /// Distance from the current location / Order total price
    @IBOutlet weak var distance: UILabel!
    
    /// status of the current order
    @IBOutlet weak var status: UILabel!
}
