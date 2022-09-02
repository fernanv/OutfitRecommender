//
//  GarmentsCustomHeaderSection.swift
//  Armario
//
//  Created by Fernando Villalba  on 10/6/22.
//

import UIKit

class GarmentsCustomHeaderSection: UITableViewHeaderFooterView {
    
    let title = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {

        if UIDevice.current.userInterfaceIdiom == .phone {
            title.font = .boldSystemFont(ofSize: 18)
        }
        else {
            title.font = .boldSystemFont(ofSize: 25)
        }
        title.textColor = .purple
        
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)

        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            title.widthAnchor.constraint(equalToConstant: 350),
            title.heightAnchor.constraint(equalToConstant: 50),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
