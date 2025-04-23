//
//  URLParameterEncoder.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import Foundation

/// A protocol that defines how to encode parameters into a `URLRequest` as part of the URL.
protocol URLParameterEncoderType: Sendable {
    /// Encodes the provided parameters into the given `URLRequest`.
    ///
    /// - Parameters:
    ///   - urlRequest: The original `URLRequest` that will be modified with encoded parameters.
    ///   - parameters: A dictionary of key-value pairs to encode into the request's URL.
    ///
    /// - Throws: An error if encoding fails, such as a missing URL.
    func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws(NetworkError)
}

/// An encoder that appends parameters to a `URLRequest` for  HTTP methods.
///
/// `URLParameterEncoder` converts a dictionary of parameters into a percent-encoded query string
/// and appends it to the request's URL.
///
/// Example usage:
/// ```swift
/// var request = URLRequest(url: URL(string: "https://api.example.com/users")!)
/// try URLParameterEncoder().encode(urlRequest: &request, with: ["page": 1, "search": "cat"])
/// print(request.url?.absoluteString) // "https://api.example.com/users?page=1&search=cat"
/// ```
struct URLParameterEncoder: URLParameterEncoderType {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws(NetworkError) {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        guard let parameters = parameters else { return }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key,value) in parameters {
                var queryValue: String? = nil
                if let parameterValue = value {
                    queryValue = "\(parameterValue)"
                }
                let queryItem = URLQueryItem(name: key, value: queryValue?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
