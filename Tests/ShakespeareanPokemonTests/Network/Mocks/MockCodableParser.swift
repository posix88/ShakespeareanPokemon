//
//  MockCodableParser.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 19/04/25.
//

import Foundation
@testable import ShakespeareanPokemon

/// A mock implementation of the `Parser` protocol for testing.
final class MockCodableParser: Parser {
    var parseCalled = false
    var parseCalledCount: Int = .zero

    /// A dictionary of stubbed results keyed by the type being decoded.
    private var stubbedResults: [String: Any] = [:]

    /// Sets the stubbed result for a given type.
    func stub<T: Decodable>(_ type: T.Type, with value: T) {
        stubbedResults[String(describing: type)] = value
    }

    /// Returns a previously stubbed result for the requested type, or throws if none is found.
    func parse<T: Decodable>(_ data: Data) throws -> T {
        parseCalled = true
        parseCalledCount += 1
        guard let result = stubbedResults[String(describing: T.self)] as? T else {
            throw NSError(domain: "MockCodableParser", code: 0, userInfo: [NSLocalizedDescriptionKey: "No stubbed value for \(T.self)"])
        }
        return result
    }
}
