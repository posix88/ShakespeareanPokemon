//
//  PokemonImageProvider.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import Foundation

/// A protocol that defines the interface for retrieving Pokémon images from a remote source.
///
/// Types conforming to `PokemonImageProviderType` are responsible for asynchronously
/// fetching a Pokémon's image data given its name.
///
/// Implementations of this protocol should handle networking, parsing, and image resolution.
///
/// - Note: The image is expected to be returned as raw `Data`, typically for rendering in a UI.
public protocol PokemonImageProviderType: Sendable {

    /// Retrieves the image data for a given Pokémon name.
    ///
    /// - Parameter pokemon: The name of the Pokémon whose image should be fetched.
    /// - Returns: The raw `Data` representing the Pokémon's image.
    /// - Throws: A `PokemonImageError` describing the failure reason.
    func image(for pokemon: String) async throws(PokemonImageError) -> Data
}

/// An object that provides Pokémon image data by performing network requests and parsing responses.
///
/// ### Usage
/// ```swift
/// let provider = PokemonImageProvider()
/// let imageData = try await provider.image(for: "pikachu")
/// let image = UIImage(data: imageData)
/// ```
public struct PokemonImageProvider: PokemonImageProviderType {
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

    /// Retrieves the image data for the given Pokémon name.
    ///
    /// - Parameter pokemon: The name of the Pokémon.
    /// - Returns: The image data (`Data`) for the Pokémon's sprite.
    /// - Throws: `PokemonImageError` if the process fails at any stage.
    public func image(for pokemon: String) async throws(PokemonImageError) -> Data {
        do {
            let pokemonData = try await networkWorker.request(PokeAPIService.pokemon(name: pokemon))
            let pokemon: PokemonResponse = try parser.parse(pokemonData)
            guard let imageURL = pokemon.sprites.front.asURL else {
                throw PokemonImageError.missingImage
            }
            return try await networkWorker.fetchData(from: imageURL)
        } catch is NetworkError {
            throw .networkFailure
        } catch let error as PokemonImageError {
            throw error
        } catch {
            throw .parsingFailure
        }
    }
}

/// An error type representing the possible failures during Pokémon image fetching.
public enum PokemonImageError: Error {
    /// The response did not contain a usable image URL.
    case missingImage

    /// A network error occurred during the request or image download.
    case networkFailure

    /// The response could not be parsed successfully.
    case parsingFailure
}
