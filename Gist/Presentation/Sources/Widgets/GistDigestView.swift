//
//  GistDigestView.swift
//  Gist
//
//  Created by Willian Fagner De Souza Policiano on 29/07/20.
//  Copyright © 2020 Willian. All rights reserved.
//

import Anchorage
import UIKit

final class GistDigestView: BaseView {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private lazy var secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var containerView: UIStackView = {
        StackViewBuilder {
            let stackView = StackViewBuilder {
                $0.spacing = 4
                $0.arrangedSubviews = [ownerNameLabel, secondaryLabel]
            }.build()

            $0.axis = .horizontal
            $0.spacing = 16
            $0.alignment = .center
            $0.arrangedSubviews = [avatarImageView, stackView]
        }.build()
    }()

    // MARK: Subviews setup

    override func setup() {
        backgroundColor = superview?.backgroundColor
        containerView.backgroundColor = superview?.backgroundColor
        
        setupAvatar()
        setupContainer()
    }

    private func setupAvatar() {
        avatarImageView.heightAnchor == 60
        avatarImageView.widthAnchor == 60
    }

    private func setupContainer() {
        addSubview(containerView)
        containerView.edgeAnchors == edgeAnchors
    }
}

extension GistDigestView {
    struct ViewModel {
        let avatarUrl: URL?
        let ownerName: String
        let secondaryText: String
    }

    func display(with viewModel: ViewModel) {
        if let url = viewModel.avatarUrl {
            avatarImageView.kf.setImage(with: url)
        }

        ownerNameLabel.text = viewModel.ownerName
        secondaryLabel.text = viewModel.secondaryText
    }
}

