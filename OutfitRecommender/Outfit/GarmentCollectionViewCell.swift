//
//  GarmentCollectionViewCell.swift
//  OutfitRecommender
//
//  Created by Fernando Villalba  on 5/9/22.
//

import UIKit

class GarmentCollectionViewCell: UICollectionViewCell {
    
    static let id = "outfitCollectionCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
}
