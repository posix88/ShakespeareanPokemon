//
//  ObservablePokemonProfileViewModel.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 23/04/25.
//

import Foundation

/// A SwiftUI-friendly protocol for a Pokémon profile view model that exposes observable state.
///
/// This protocol is intended for use in SwiftUI views. It allows observing changes to
/// the Pokémon's description, image data, and loading status through property bindings.
@MainActor
protocol ObservablePokemonProfileViewModelType: ObservableObject {
    /// The Shakespearean description of the Pokémon.
    var description: String { get }

    /// The Pokémon's image data.
    var imageData: Data? { get }

    /// The current loading status of the view model.
    var status: ObservablePokemonProfileViewModel.Status { get }

    /// Asynchronously loads profile data for the specified Pokémon name.
    /// - Parameter name: The name of the Pokémon to load data for.
    func load(for name: String) async
}

/// A SwiftUI-compatible wrapper around `PokemonProfileViewModelType`,
/// exposing observable properties for use in reactive views.
///
/// This class listens to events from a platform-agnostic view model and
/// exposes its state through `@Published` properties to drive SwiftUI updates.
/// It manages loading status internally and reports errors via state rather than callbacks.
final class ObservablePokemonProfileViewModel: ObservablePokemonProfileViewModelType {
    /// A Shakespearean description of the Pokémon.
    @Published var description: String = ""

    /// The image data of the Pokémon, if available.
    @Published var imageData: Data?

    /// The current status of the view model.
    @Published var status: Status = .idle

    /// Represents the loading state of the view model.
    enum Status {
        /// No operation in progress.
        case idle
        /// Currently loading data.
        case loading
        /// An error occurred during loading.
        case error
    }

    /// The underlying platform-independent view model.
    private var base: any PokemonProfileViewModelType

    /// Creates a new observable view model that wraps a `PokemonProfileViewModelType`.
    /// - Parameter base: The view model used to fetch data. Defaults to `PokemonProfileViewModel()`.
    init(base: any PokemonProfileViewModelType = PokemonProfileViewModel()) {
        self.base = base

        self.base.onDataLoaded = { [weak self] data, desc in
            self?.imageData = data
            self?.description = desc
            self?.status = .idle
        }

        self.base.onError = { [weak self] error in
            self?.description = error
            self?.status = .error
        }
    }

    /// Starts loading the Pokémon's profile data.
    ///
    /// The view model transitions to `.loading` during the fetch, and then either
    /// `.idle` or `.error` depending on the result.
    /// - Parameter name: The name of the Pokémon to load.
    func load(for name: String) async {
        status = .loading
        await base.load(for: name)
    }
}
