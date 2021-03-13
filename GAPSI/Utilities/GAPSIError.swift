//
//  GAPSIError.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import Foundation

enum GAPSIError: String, Error {
    
    case invalidProductSearch    = "This product search created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    case alreadyInHistory = "You've already searched for this product. You must REALLY like it! 😍."
    case unableToSaveToHistory   = "There was an error saving this product to the history. Please try again."
}
