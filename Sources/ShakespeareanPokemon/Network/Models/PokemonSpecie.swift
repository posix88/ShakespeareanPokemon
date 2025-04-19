//
//  PokemonSpecie.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import Foundation

struct PokemonSpecieResponse: Identifiable, Equatable {
    let id: Int
    let name: String
    let flavorTextEntries: [FlavortextEntry]

    struct FlavortextEntry: Equatable {
        let flavorText: String
        let language: Language

        struct Language: Equatable {
            let code: LanguageCode

            /// A language identifier used in API responses.
            enum LanguageCode: String, Decodable, Equatable {
                case english = "en"
                case italian = "it"

                case unknown
            }
        }
    }
}

extension PokemonSpecieResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case flavorTextEntries = "flavor_text_entries"
    }
}

extension PokemonSpecieResponse.FlavortextEntry: Decodable {
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }
}

extension PokemonSpecieResponse.FlavortextEntry.Language: Decodable {
    enum CodingKeys: String, CodingKey {
        case code = "name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawCode = try container.decode(String.self, forKey: .code)
        self.code = LanguageCode(rawValue: rawCode) ?? .unknown
    }
}
