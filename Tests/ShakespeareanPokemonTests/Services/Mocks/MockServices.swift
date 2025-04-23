//
//  File.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 22/04/25.
//

import Foundation
@testable import ShakespeareanPokemon

final class MockPokemonImageProvider: PokemonImageProviderType, @unchecked Sendable {
    var invokedImageForPokemon: Bool = false
    var invokedImageForPokemonParameter: String?
    var stubbedImageForPokemonResult: Data!
    var stubbedImageForPokemonError: PokemonImageError?
    func image(for pokemon: String) async throws(PokemonImageError) -> Data {
        invokedImageForPokemon = true
        invokedImageForPokemonParameter = pokemon
        if let stubbedImageForPokemonError {
            throw stubbedImageForPokemonError
        }
        return stubbedImageForPokemonResult
    }
}

final class MockShakespeareanPokemonDescriptor: ShakespeareanPokemonDescriptorType, @unchecked Sendable {
    var invokedShakespeareanDescriptionForPokemon: Bool = false
    var invokedShakespeareanDescriptionForPokemonParameterPokemon: String?
    var invokedShakespeareanDescriptionForPokemonParameterLanguage: SupportedLanguage?
    var stubbedShakespeareanDescriptionForPokemonResult: String!
    var stubbedShakespeareanDescriptionForPokemonError: ShakespeareanError?
    func shakespeareanDescription(for pokemon: String, language: SupportedLanguage) async throws(ShakespeareanError) -> String {
        invokedShakespeareanDescriptionForPokemon = true
        invokedShakespeareanDescriptionForPokemonParameterPokemon = pokemon
        invokedShakespeareanDescriptionForPokemonParameterLanguage = language
        if let stubbedShakespeareanDescriptionForPokemonError {
            throw stubbedShakespeareanDescriptionForPokemonError
        }
        return stubbedShakespeareanDescriptionForPokemonResult
    }
}

final class MockPokemonProfileViewModelType: PokemonProfileViewModelType, @unchecked Sendable {
    var onError: ((String) -> Void)?
    var onDataLoaded: ((Data, String) -> Void)?

    var invokedLoad: Bool = false
    func load(for name: String) async {
        invokedLoad = true
    }
}
