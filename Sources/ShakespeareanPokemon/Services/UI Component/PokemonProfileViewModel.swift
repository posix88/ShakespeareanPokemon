//
//  PokemonProfileViewModel.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 19/04/25.
//

import Foundation

@MainActor
protocol PokemonProfileViewModelType: Sendable {
    var onError: ((String) -> Void)? { get set }
    var onDataLoaded: ((Data, String) -> Void)? { get set }

    func load(for name: String) async
}

/// ViewModel responsible for fetching and exposing Pokémon data to the view.
final class PokemonProfileViewModel: PokemonProfileViewModelType {
    private let descriptor: ShakespeareanPokemonDescriptorType
    private let imageProvider: PokemonImageProviderType

    var onError: ((String) -> Void)?
    var onDataLoaded: ((Data, String) -> Void)?

    init(
        descriptor: ShakespeareanPokemonDescriptorType = ShakespeareanPokemonDescriptor(),
        imageProvider: PokemonImageProviderType = PokemonImageProvider()
    ) {
        self.descriptor = descriptor
        self.imageProvider = imageProvider
    }

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
