//
//  HTTPMethod.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import Foundation

/// An enumeration representing the supported HTTP methods for network requests.
enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
