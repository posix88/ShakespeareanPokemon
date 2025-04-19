//
//  Service.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import Foundation

typealias Parameters = [String: Any?]

/// A protocol that defines the core components required to perform a network request.
///
/// Types conforming to `Service` represent a single network endpoint,
/// including its URL, path, HTTP method, and optional parameters.
///
/// Example usage:
/// ```swift
/// struct UserService: Service {
///     var endpoint: URL { URL(string: "https://api.example.com")! }
///     var path: String { "/users" }
///     var httpMethod: HTTPMethod { .get }
///     var parameters: Parameters? { nil }
/// }
/// ```
protocol Service: Sendable, Hashable {

    /// The base URL of the service endpoint.
    ///
    /// Example: `https://api.example.com`
    var endpoint: URL { get }

    /// The specific path appended to the endpoint to form the full URL.
    ///
    /// Example: `/users`
    var path: String { get }

    /// The HTTP method used for the request (e.g., GET, POST).
    var httpMethod: HTTPMethod { get }

    /// Optional query parameters to be sent with the request.
    var parameters: Parameters? { get }
}
