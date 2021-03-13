//
//  Product.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import Foundation

struct Product: Codable, Hashable {
    var id: String
    var title: String
    var price: Double
    var image: String
}
