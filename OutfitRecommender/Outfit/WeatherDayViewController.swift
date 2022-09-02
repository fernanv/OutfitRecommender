//
//  WeatherDayView.swift
//  Armario
//
//  Created by Fernando Villalba  on 8/6/22.
//

import Foundation
import UIKit

class PopUpWindow: UIViewController {

    private let popUpWindowView = PopUpWindowView()
    
    init(title: String, icon: String, text: String, buttontext: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.popupTitle.text = title
        popUpWindowView.popupImage.image = UIImage(named: icon)
        popUpWindowView.popupText.text = text
        popUpWindowView.popupButton.setTitle(buttontext, for: .normal)
        popUpWindowView.popupButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view = popUpWindowView
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

}

private class PopUpWindowView: UIView {
    
    let popupView = UIView(frame: CGRect.zero)
    let popupTitle = UILabel(frame: CGRect.zero)
    var popupImage = UIImageView(frame: CGRect.zero)
    let popupText = UILabel(frame: CGRect.zero)
    let popupButton = UIButton(frame: CGRect.zero)
    
    let BorderWidth: CGFloat = 2.0
    
    init() {
        super.init(frame: CGRect.zero)
        // Semi-transparent background
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Popup Background
        popupView.backgroundColor = UIColor.purple
        popupView.layer.borderWidth = BorderWidth
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = UIColor.white.cgColor
        popupView.layer.cornerRadius = 10
        
        // Popup Title
        popupTitle.textColor = UIColor.white
       // popupTitle.backgroundColor = UIColor.colorFromHex("#9E1C40")
        popupTitle.layer.masksToBounds = true
        popupTitle.adjustsFontSizeToFitWidth = true
        popupTitle.clipsToBounds = true
        popupTitle.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        popupTitle.numberOfLines = 1
        popupTitle.textAlignment = .center
        
        // Popup Image
        popupImage.contentMode = UIView.ContentMode.scaleAspectFit
        popupImage.frame.size.width = 50
        popupImage.frame.size.height = 50
        popupImage.center = popupView.center
        
        // Popup Text
        popupText.textColor = UIColor.white
        popupText.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        popupText.numberOfLines = 1
        popupText.textAlignment = .center
        
        // Popup Button
        popupButton.setTitleColor(UIColor.yellow, for: .normal)
        popupButton.titleLabel?.font = UIFont.systemFont(ofSize: 19.0, weight: .semibold)
        //popupButton.backgroundColor = UIColor.colorFromHex("#9E1C40")
        
        popupView.addSubview(popupTitle)
        popupView.addSubview(popupImage)
        popupView.addSubview(popupText)
        popupView.addSubview(popupButton)
        
        // Add the popupView(box) in the PopUpWindowView (semi-transparent background)
        addSubview(popupView)
        
        // PopupView constraints
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        // PopupTitle constraints
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupTitle.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupTitle.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupTitle.topAnchor.constraint(equalTo: popupView.topAnchor, constant: BorderWidth),
            popupTitle.heightAnchor.constraint(equalToConstant: 55)
            ])
        
        // PopupImage constraints
        popupImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupImage.heightAnchor.constraint(equalToConstant: 50),
            popupImage.topAnchor.constraint(equalTo: popupTitle.topAnchor, constant: 50),
            popupImage.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 5),
            popupImage.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -5),
            ])
        
        // PopupText constraints
        popupText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupText.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            popupText.topAnchor.constraint(equalTo: popupImage.topAnchor, constant: 50),
            popupText.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 15),
            popupText.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
            popupText.bottomAnchor.constraint(equalTo: popupButton.topAnchor, constant: -8)
            ])

        
        // PopupButton constraints
        popupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupButton.heightAnchor.constraint(equalToConstant: 44),
            popupButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -BorderWidth)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
