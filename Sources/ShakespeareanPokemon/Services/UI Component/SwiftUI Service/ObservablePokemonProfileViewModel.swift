//
//  ObservablePokemonProfileViewModel.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 23/04/25.
//

import Foundation

@MainActor
protocol ObservablePokemonProfileViewModelType: ObservableObject {
    var description: String { get }
    var imageData: Data? { get }
    var status: ObservablePokemonProfileViewModel.Status { get }

    func load(for name: String) async
}

final class ObservablePokemonProfileViewModel: ObservablePokemonProfileViewModelType {
    @Published var description: String = ""
    @Published var imageData: Data?
    @Published var status: Status = .idle

    enum Status {
        case loading
        case idle
        case error
    }

    private var base: any PokemonProfileViewModelType

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

    func load(for name: String) async {
        status = .loading
        await base.load(for: name)
    }
}
