//
//  HighScore+CoreDataProperties.swift
//  ZagMan
//
//  Created by Tibbetts, Lucille Rose on 12/10/18.
//  Copyright © 2018 Tibbetts, Lucille Rose. All rights reserved.
//
//

import Foundation
import CoreData


extension HighScore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HighScore> {
        return NSFetchRequest<HighScore>(entityName: "HighScore")
    }

    @NSManaged public var name: String
    @NSManaged public var score: Int32

}
