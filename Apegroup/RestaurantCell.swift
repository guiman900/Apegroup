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
 TableView cell used on the MasterViewController
 */
class RestaurantCell: UITableViewCell {
    // - MARK: properties
    
    /// Restaurant name.
    @IBOutlet weak var name: UILabel!
    
    /// Restaurant Address
    @IBOutlet weak var address: UILabel!
    
    /// Distance from the current location
    @IBOutlet weak var distance: UILabel!
}
