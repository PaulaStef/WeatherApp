//
//  HourlyWeatherDetailsCell.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/2/22.
//

import Foundation
import UIKit

class HourlyWeatherDetailsCell: UICollectionViewCell {
    
    let titleLabel : UILabel = UILabel()
    let descriptionLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        titleLabel.backgroundColor = .clear
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        titleLabel.heightAnchor.constraint(equalToConstant: 50),
        
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
