//
//  PokemonProfileViewModel.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 19/04/25.
//

import Foundation

/// A protocol defining the interface for a Pokémon profile view model.
///
/// Conforming types are responsible for asynchronously loading a Pokémon's image
/// and a Shakespearean-style description, and reporting results through closures.
@MainActor
protocol PokemonProfileViewModelType: Sendable {
    /// Closure called when an error occurs during loading.
    var onError: ((String) -> Void)? { get set }

    /// Closure called when both image data and description are successfully loaded.
    /// - Parameters:
    ///   - Data: The raw image data of the Pokémon.
    ///   - String: A Shakespearean description of the Pokémon.
    var onDataLoaded: ((Data, String) -> Void)? { get set }

    /// Starts the asynchronous loading of a Pokémon’s profile data.
    /// - Parameter name: The name of the Pokémon to load data for.
    func load(for name: String) async
}

/// A concrete implementation of `PokemonProfileViewModelType` that fetches
/// a Shakespearean description and image data for a given Pokémon.
///
/// This view model handles asynchronous operations and communicates results
/// via closures, making it suitable for use in UIKit environments. For SwiftUI,
/// consider wrapping this class in an `ObservableObject` if reactive state is needed.
///
/// The data sources are injected via protocols for improved testability and flexibility.
final class PokemonProfileViewModel: PokemonProfileViewModelType {
    private let descriptor: ShakespeareanPokemonDescriptorType
    private let imageProvider: PokemonImageProviderType

    /// Called when an error occurs during data loading.
    var onError: ((String) -> Void)?

    /// Called when both the image and description are successfully loaded.
    var onDataLoaded: ((Data, String) -> Void)?

    /// Initializes the view model with optional dependencies for data fetching.
    /// - Parameters:
    ///   - descriptor: An object that provides a Shakespearean Pokémon description.
    ///   - imageProvider: An object that provides Pokémon image data.
    init(
        descriptor: ShakespeareanPokemonDescriptorType = ShakespeareanPokemonDescriptor(),
        imageProvider: PokemonImageProviderType = PokemonImageProvider()
    ) {
        self.descriptor = descriptor
        self.imageProvider = imageProvider
    }

    /// Asynchronously loads the Shakespearean description and image of the given Pokémon name.
    /// If both requests succeed, `onDataLoaded` is called. If any fail, `onError` is triggered.
    /// - Parameter name: The name of the Pokémon to fetch data for.
    func load(for name: String) async {
        do {
            async let description = try await descriptor.shakespeareanDescription(for: name, language: .english)
            async let imageData = try await imageProvider.image(for: name)
            try await onDataLoaded?(imageData, description)
        } catch {
            onError?("Failed to load Pokémon data.")
        }
    }
}
