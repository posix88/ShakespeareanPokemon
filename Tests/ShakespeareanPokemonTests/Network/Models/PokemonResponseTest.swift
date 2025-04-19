//
//  PokemonResponseTest.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 19/04/25.
//

import XCTest
@testable import ShakespeareanPokemon

final class PokemonResponseTest: XCTestCase {
    let JSON: String = """
        {
            "id": 25,
            "name": "pikachu",
             "sprites": {
                "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/25.png",
                "back_female": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/25.png",
                "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/25.png",
                "back_shiny_female": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/25.png",
                "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png",
                "front_female": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/25.png",
                "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/25.png",
                "front_shiny_female": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/25.png"
            }
        }
        """

    func testDecodable() throws {
        let parser = CodableParser()
        let result: PokemonResponse = try parser.parse(JSON.data(using: .utf8)!)

        XCTAssertEqual(result.id, 25)
        XCTAssertEqual(result.name, "pikachu")
        XCTAssertEqual(result.sprites.front, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")
    }
}
