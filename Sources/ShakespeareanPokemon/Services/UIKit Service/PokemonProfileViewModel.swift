//
//  PokemonProfileViewModel.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 19/04/25.
//

import Foundation

@MainActor
public protocol PokemonProfileViewModelType: Sendable {
    var onError: ((String) -> Void)? { get set }
    var onDataLoaded: ((Data, String) -> Void)? { get set }

    func load(for name: String) async
}

/// ViewModel responsible for fetching and exposing Pokémon data to the view.
public final class PokemonProfileViewModel: PokemonProfileViewModelType {
    private let descriptor: ShakespeareanPokemonDescriptorType
    private let imageProvider: PokemonImageProviderType

    public var onError: ((String) -> Void)?
    public var onDataLoaded: ((Data, String) -> Void)?

    public init(
        descriptor: ShakespeareanPokemonDescriptorType = ShakespeareanPokemonDescriptor(),
        imageProvider: PokemonImageProviderType = PokemonImageProvider()
    ) {
        self.descriptor = descriptor
        self.imageProvider = imageProvider
    }

    @MainActor
    public func load(for name: String) async {
        do {
            async let description = try await descriptor.shakespeareanDescription(for: name)
            async let imageData = try await imageProvider.image(for: name)
            try await onDataLoaded?(imageData, description)
        } catch {
            onError?("Failed to load Pokémon data.")
        }
    }
}
