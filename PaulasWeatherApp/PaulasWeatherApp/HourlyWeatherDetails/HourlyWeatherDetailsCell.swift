//
//  HourlyWeatherDetailsCell.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/10/22.
//

import UIKit

class HourlyWeatherDetailsCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.cornerRadius = 7.0
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubviewAligned(blurEffect)
        setTitleLabel()
        setDescriptionLabel()
    }
    
    private func setTitleLabel() {
        titleLabel.backgroundColor = .clear
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 20)
        blurEffect.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setDescriptionLabel() {
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 18)
        blurEffect.contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
