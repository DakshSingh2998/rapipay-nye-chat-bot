//
//  TDataCore+CoreDataProperties.swift
//  Chat
//
//  Created by Daksh on 24/03/23.
//
//

import Foundation
import CoreData


extension TDataCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TDataCore> {
        return NSFetchRequest<TDataCore>(entityName: "TDataCore")
    }

    @NSManaged public var text: String?
    @NSManaged public var toMany: NSOrderedSet?
    @NSManaged public var toOne: TDataCore?

}

// MARK: Generated accessors for toMany
extension TDataCore {

    @objc(insertObject:inToManyAtIndex:)
    @NSManaged public func insertIntoToMany(_ value: TDataCore, at idx: Int)

    @objc(removeObjectFromToManyAtIndex:)
    @NSManaged public func removeFromToMany(at idx: Int)

    @objc(insertToMany:atIndexes:)
    @NSManaged public func insertIntoToMany(_ values: [TDataCore], at indexes: NSIndexSet)

    @objc(removeToManyAtIndexes:)
    @NSManaged public func removeFromToMany(at indexes: NSIndexSet)

    @objc(replaceObjectInToManyAtIndex:withObject:)
    @NSManaged public func replaceToMany(at idx: Int, with value: TDataCore)

    @objc(replaceToManyAtIndexes:withToMany:)
    @NSManaged public func replaceToMany(at indexes: NSIndexSet, with values: [TDataCore])

    @objc(addToManyObject:)
    @NSManaged public func addToToMany(_ value: TDataCore)

    @objc(removeToManyObject:)
    @NSManaged public func removeFromToMany(_ value: TDataCore)

    @objc(addToMany:)
    @NSManaged public func addToToMany(_ values: NSOrderedSet)

    @objc(removeToMany:)
    @NSManaged public func removeFromToMany(_ values: NSOrderedSet)

}

extension TDataCore : Identifiable {

}
