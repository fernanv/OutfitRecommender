//
//  UserViewController.swift
//  Armario
//
//  Created by Fernando Villalba  on 9/5/22.
//

import UIKit
import SwiftUI
import CoreData

class UserViewController : UIViewController {
    
    var user: UserViewModel!

    var viewCtrl: UIHostingController<Login>?
    
    /*init(user: UserViewModel) {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCtrl = UIHostingController(rootView: Login(login: Binding.constant(true), perfil: Binding.constant(false), usuario: self.user))

        addChild(viewCtrl!)
        view.addSubview(viewCtrl!.view)
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        viewCtrl!.view.translatesAutoresizingMaskIntoConstraints = false
        viewCtrl!.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewCtrl!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewCtrl!.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewCtrl!.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
