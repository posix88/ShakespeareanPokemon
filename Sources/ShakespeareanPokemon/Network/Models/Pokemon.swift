//
//  Pokemon.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

struct PokemonResponse: Identifiable, Equatable, Decodable {
    let id: Int
    let name: String
    let sprites: Sprites

    struct Sprites: Equatable, Decodable {
        let front: String

        enum CodingKeys: String, CodingKey {
            case front = "front_default"
        }
    }
}
