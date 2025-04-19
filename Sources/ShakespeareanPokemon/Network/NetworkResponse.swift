//
//  NetworkResponse.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

/// Represents the result of a network response based on its HTTP status code.
enum NetworkResponse {
    /// The request was successful (status code 2xx).
    case success

    /// The request failed due to authentication issues (e.g., 401 Unauthorized, 403 Forbidden).
    case authenticationError

    /// The request was malformed or contained bad data (e.g., 400 Bad Request).
    case badRequest

    /// The requested resource was not found or is not allowed (e.g., 404 Not Found, 405 Method Not Allowed).
    case notFound

    /// The server encountered an error (e.g., 5xx Server Errors).
    case serverError

    /// The request failed for an unknown or unhandled reason.
    case failed
}
