//
//  PokemonProfileView.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 19/04/25.
//

import UIKit

/// A simple reusable `UIView` that displays a Pokémon's sprite and its Shakespearean description.
public class PokemonProfileView: UIView {

    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.isHidden = true
        return button
    }()

    private var viewModel: any PokemonProfileViewModelType
    private var task: Task<(), Never>?

    /// The name of the Pokémon whose data will be displayed.
    public var pokemonName: String? {
        didSet {
            loadData()
        }
    }

    public override init(frame: CGRect) {
        self.viewModel = PokemonProfileViewModel()
        super.init(frame: frame)
        setupUI()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        self.viewModel = PokemonProfileViewModel()
        super.init(coder: coder)
        setupUI()
        bindViewModel()
    }

    deinit {
        task?.cancel()
    }

    private func setupUI() {
        imageView.contentMode = .scaleAspectFit
        descriptionLabel.numberOfLines = .zero
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        retryButton.addAction(UIAction(identifier: .init(rawValue: "retryAction")) { [weak self] _ in self?.loadData() }, for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [imageView, descriptionLabel, activityIndicator, retryButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }

    private func bindViewModel() {
        viewModel.onDataLoaded = { [weak self] data, description in
            self?.imageView.image = UIImage(data: data)
            self?.descriptionLabel.text = description
            self?.activityIndicator.stopAnimating()
            self?.retryButton.isHidden = true
        }

        viewModel.onError = { [weak self] message in
            self?.descriptionLabel.text = message
            self?.activityIndicator.stopAnimating()
            self?.retryButton.isHidden = false
        }
    }

    private func loadData() {
        task?.cancel()
        guard let name = pokemonName else {
            return
        }
        activityIndicator.startAnimating()
        descriptionLabel.text = nil
        imageView.image = nil
        retryButton.isHidden = true
        task = Task {
            await viewModel.load(for: name)
        }
    }
}
