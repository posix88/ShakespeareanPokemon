//
//  HTTPMethod.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import Foundation

/// An enumeration representing the supported HTTP methods for network requests.
///
/// Use this enum to specify the HTTP method when configuring a URL request.
///
/// Example usage:
/// ```swift
/// var request = URLRequest(url: url)
/// request.httpMethod = HTTPMethod.get.rawValue
/// ```
///
/// - Note: This enum conforms to `RawRepresentable` with `String` as the raw type.
enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
