//
//  MenuCell.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit


/**
 Menu Cell Model used on the DetailViewController.
 */
internal class MenuCell: UITableViewCell {
    // - MARK: properties
    
    /// Menu name.
    @IBOutlet weak var name: UILabel!
    
    /// Menu address
    @IBOutlet weak var price: UILabel!
    
    /// List of available topping
    @IBOutlet weak var topping: UILabel!
    
    /// image of the menu
    @IBOutlet weak var menuImage: UIImageView!
    
    /// number of menu ordered
    @IBOutlet weak var quantity: UILabel!
}
