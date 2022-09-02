//
//  MyCollectionViewCell.swift
//  Armario
//
//  Created by Fernando Villalba  on 4/4/22.
//

import UIKit

class GarmentsCollectionViewCell: UICollectionViewCell {
    
    var garmentImage: UIImage? {
        didSet {
            guard let img = garmentImage else { return }
            garmentImageView.image = img
        }
    }
    
    fileprivate let garmentImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(garmentImageView)
        garmentImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        garmentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        garmentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        garmentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}
