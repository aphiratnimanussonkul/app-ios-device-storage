//
//  User+CoreDataProperties.swift
//  app-ios-device-storage
//
//  Created by ODDS on 17/2/2563 BE.
//  Copyright © 2563 ODDS. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?

}
