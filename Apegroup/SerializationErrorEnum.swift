//
//  SerializationErrorEnum.swift
//  Apegroup
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 enum used for the serialization errors.
 */
enum SerializationError: Error {
    case missing(String)
    case invalid(String)
}
