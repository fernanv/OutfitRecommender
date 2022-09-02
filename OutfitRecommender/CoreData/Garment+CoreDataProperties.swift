//
//  Garment+CoreDataProperties.swift
//  
//
//  Created by Fernando Villalba  on 26/4/22.
//
//

import Foundation
import CoreData
import UIKit


extension Garment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Garment> {
        return NSFetchRequest<Garment>(entityName: "Garment")
    }

    @NSManaged public var color: String?
    @NSManaged public var image: UIImage?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var user: User?

}
