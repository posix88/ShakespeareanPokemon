//
//  PokeAPIService.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//
import Foundation

enum PokeAPIService {
    case pokemon(name: String)
    case pokemonSpecies(name: String)
}

extension PokeAPIService: Service {

    var serviceBaseURL : String {
        "https://pokeapi.co/api/v2"
    }

    var endpoint: URL {
        guard let url = URL(string: serviceBaseURL) else { fatalError("baseURL could not be configured.")}
        return url.appendingPathComponent(path)
    }

    var path: String {
        switch self {
        case .pokemon(let name): return "/pokemon/\(name)"
        case .pokemonSpecies(let name): return "pokemon-species/\(name)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .pokemon, .pokemonSpecies:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .pokemon, .pokemonSpecies:
            return nil
        }
    }
}

extension PokeAPIService: Equatable {}
