//
//  PokeAPIServiceTests.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 22/04/25.
//

@testable import ShakespeareanPokemon
import XCTest

final class PokeAPIServiceTests: XCTestCase {

    func testPokemonServiceAPI() {
        let api = PokeAPIService.pokemon(name: "Pikachu")

        XCTAssertEqual(api.endpoint.absoluteString, "https://pokeapi.co/api/v2/pokemon/Pikachu")
        XCTAssertEqual(api.path, "/pokemon/Pikachu")
        XCTAssertEqual(api.httpMethod, .get)
        XCTAssertNil(api.parameters)
    }

    func testPokemonSpecieServiceAPI() {
        let api = PokeAPIService.pokemonSpecies(name: "Pikachu")

        XCTAssertEqual(api.endpoint.absoluteString, "https://pokeapi.co/api/v2/pokemon-species/Pikachu")
        XCTAssertEqual(api.path, "/pokemon-species/Pikachu")
        XCTAssertEqual(api.httpMethod, .get)
        XCTAssertNil(api.parameters)
    }
}
