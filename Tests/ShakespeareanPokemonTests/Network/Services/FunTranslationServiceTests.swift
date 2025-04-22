//
//  FunTranslationServiceTests.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 22/04/25.
//

@testable import ShakespeareanPokemon
import XCTest

final class FunTranslationServiceTests: XCTestCase {

    func testPokemonSpecieServiceAPI() {
        let api = FunTranslationService.shakespeare(text: "Lord Pikachu")

        XCTAssertEqual(api.endpoint.absoluteString, "https://api.funtranslations.com/translate/shakespeare.json")
        XCTAssertEqual(api.path, "/shakespeare.json")
        XCTAssertEqual(api.httpMethod, .get)
        XCTAssertEqual(api.parameters as? [String: String], ["text" : "Lord Pikachu"])
    }
}
