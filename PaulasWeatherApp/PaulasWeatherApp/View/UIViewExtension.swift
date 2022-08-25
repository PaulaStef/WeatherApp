//
//  UIViewExtension.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/18/22.
//
import UIKit

extension UIView {
    func addSubviewAligned(_ subview: UIView){
        addSubview(subview)
        NSLayoutConstraint.activate([
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subview.topAnchor.constraint(equalTo: self.topAnchor),
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor) ])
    }
}
