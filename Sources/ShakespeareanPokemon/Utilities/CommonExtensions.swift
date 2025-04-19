//
//  CommonExtensions.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import Foundation

extension String {
    /// Return an `URL` from the provided string
    var asURL: URL? {
        guard let url = URL(string: self) else {
            return nil
        }
        return url
    }
}
