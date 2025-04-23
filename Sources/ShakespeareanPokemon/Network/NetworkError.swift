//
//  NetworkError.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

/// An enumeration describing possible errors encountered during a network request.
enum NetworkError: Error {

    /// Indicates that the request was attempted without a valid URL.
    case missingURL

    /// Indicates that the request succeeded but returned no data.
    case noData

    /// Represents a categorized network issue based on the `NetworkResponse` enum.
    ///
    /// - Parameter issue: A `NetworkResponse` case indicating the nature of the failure.
    case responseIssue(_ issue: NetworkResponse)

    /// Represents an unknown error that doesn't fall into the predefined categories.
    ///
    /// - Parameter error: An optional `Error` object describing the original failure.
    case unknownError(_ error: Error?)
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.noData, .noData), (.missingURL, .missingURL):
            return true

        case (.responseIssue(let issue1), .responseIssue(let issue2)):
            return issue1 == issue2

        case (.unknownError(_), .unknownError(_)):
            return true

        default:
            return false
        }
    }
}
