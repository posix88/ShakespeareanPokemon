//
//  ShakespeareanPokemonDescriptor.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

/// A protocol that defines an interface for retrieving a Shakespearean description of a Pokémon.
///
/// Types conforming to `ShakespeareanPokemonDescriptorType` are responsible for fetching a Pokémon's
/// species description and transforming it into Shakespearean English.
///
/// - Note: The result is returned as a `String`, and the method is asynchronous and throwable.
public protocol ShakespeareanPokemonDescriptorType: Sendable {

    /// Returns a Shakespearean-style description of the specified Pokémon.
    ///
    /// - Parameter pokemon: The name of the Pokémon.
    /// - Returns: A Shakespearean-translated description string.
    /// - Throws: An `SPDError` if the process fails at any stage (network, parsing, translation).
    func shakespeareanDescription(for pokemon: String, language: SupportedLanguage) async throws(ShakespeareanPokemonDescriptor.SPDError) -> String
}

/// An object that fetches and transforms a Pokémon's description into Shakespearean English.
///
/// ### Usage
/// ```swift
/// let descriptor = ShakespeareanPokemonDescriptor()
/// let description = try await descriptor.shakespeareanDescription(for: "charizard")
/// print(description) // "Charizard, the flame Pokémon, speaketh mightily..."
/// ```
public struct ShakespeareanPokemonDescriptor: ShakespeareanPokemonDescriptorType {
    private let networkWorker: any NetworkLayer
    private let parser: any Parser

    /// Internal initializer for injecting a custom network layer (useful for testing).
    ///
    /// - Parameter networkWorker: A custom network worker conforming to `NetworkLayer`.
    init(networkWorker: any NetworkLayer, parser: any Parser = CodableParser()) {
        self.networkWorker = networkWorker
        self.parser = parser
    }

    /// Public initializer for SDK consumers using default networking.
    public init() {
        self.networkWorker = NetworkLayerWorker()
        self.parser = CodableParser()
    }

    /// Error type representing the failure scenarios during description fetching and translation.
    public enum SPDError: Error {
        /// The Pokémon description could not be found or was not available in English.
        case missingTranslation

        /// A network-related failure occurred (e.g., timeout, connectivity).
        case networkFailure

        /// A decoding or parsing error occurred with the response data.
        case parsingFailure
    }

    /// Fetches a Shakespearean translation of a Pokémon's description.
    ///
    /// - Parameter pokemon: The name of the Pokémon to describe.
    /// - Returns: A string containing the translated description.
    /// - Throws: An `SPDError` describing the failure reason.
    public func shakespeareanDescription(for pokemon: String, language: SupportedLanguage) async throws(SPDError) -> String {
        do {
            let pokemonData = try await networkWorker.request(PokeAPIService.pokemonSpecies(name: pokemon))
            let pokemonSpecie: PokemonSpecieResponse = try parser.parse(pokemonData)
            let englishDescription = pokemonSpecie.flavorTextEntries.first(where: { $0.language.code == language.toModel })?.flavorText
            guard let englishDescription else {
                throw SPDError.missingTranslation
            }
            let shakespeareData = try await networkWorker.request(FunTranslationService.shakespeare(text: englishDescription))
            let translation: ShakespeareTranslation = try parser.parse(shakespeareData)
            return translation.translated
        } catch is NetworkError {
            throw .networkFailure
        } catch let error as SPDError {
            throw error
        } catch {
            throw .parsingFailure
        }
    }
}

public enum SupportedLanguage: Sendable {
    case english

    var toModel: PokemonSpecieResponse.FlavortextEntry.Language.LanguageCode {
        switch self {
        case .english: .english
        }
    }
}
