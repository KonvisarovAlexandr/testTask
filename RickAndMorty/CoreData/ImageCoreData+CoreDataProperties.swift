//
//  ImageCoreData+CoreDataProperties.swift
//  RickAndMorty
//

import Foundation
import CoreData


extension ImageCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCoreData> {
        return NSFetchRequest<ImageCoreData>(entityName: "ImageCoreData")
    }

    @NSManaged public var image: Data?
    @NSManaged public var id: Int16

}

extension ImageCoreData : Identifiable {

}
