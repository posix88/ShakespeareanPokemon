//
//  CodableParser.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//
import Foundation

/// A protocol defining a generic interface for parsing raw `Data` into a `Decodable` model.
protocol Parser: Sendable {
    /// Attempts to parse raw `Data` into a strongly-typed model.
    ///
    /// - Parameter data: The raw data to decode.
    /// - Returns: A decoded model of type `T`.
    /// - Throws: An error if decoding fails.
    func parse<T: Decodable>(_ data: Data) throws -> T
}


/// A concrete implementation of the `Parser` protocol using Swift's `Codable` system.
struct CodableParser: Parser {
    /// Decodes the provided `Data` into a model of type `T` using `JSONDecoder`.
    ///
    /// - Parameter data: The JSON data to decode.
    /// - Returns: A model instance of type `T`.
    /// - Throws: A decoding error if the data cannot be parsed into the desired type.
    func parse<T: Decodable>(_ data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}
