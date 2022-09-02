//
//  User+CoreDataProperties.swift
//  
//
//  Created by Fernando Villalba  on 26/4/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var garments: NSSet?

}

// MARK: Generated accessors for garments
extension User {

    @objc(addGarmentsObject:)
    @NSManaged public func addToGarments(_ value: Garment)

    @objc(removeGarmentsObject:)
    @NSManaged public func removeFromGarments(_ value: Garment)

    @objc(addGarments:)
    @NSManaged public func addToGarments(_ values: NSSet)

    @objc(removeGarments:)
    @NSManaged public func removeFromGarments(_ values: NSSet)

}
