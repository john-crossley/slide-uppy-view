//
//  ProductCell.swift
//  SlideUppyView
//
//  Created by John Crossley on 30/06/2017.
//  Copyright © 2017 John Crossley. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func show(product: Product) {
        addSubview(titleLabel)
        backgroundColor = .yellow
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        titleLabel.text = product.title
    }
}
