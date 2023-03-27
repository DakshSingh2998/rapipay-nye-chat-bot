//
//  TDataCore+CoreDataProperties.swift
//  Chat
//
//  Created by Daksh on 27/03/23.
//
//

import Foundation
import CoreData


extension TDataCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TDataCore> {
        return NSFetchRequest<TDataCore>(entityName: "TDataCore")
    }

    @NSManaged public var text: String?
    @NSManaged public var children: NSOrderedSet?
    @NSManaged public var parents: NSOrderedSet?

}

// MARK: Generated accessors for children
extension TDataCore {

    @objc(insertObject:inChildrenAtIndex:)
    @NSManaged public func insertIntoChildren(_ value: TDataCore, at idx: Int)

    @objc(removeObjectFromChildrenAtIndex:)
    @NSManaged public func removeFromChildren(at idx: Int)

    @objc(insertChildren:atIndexes:)
    @NSManaged public func insertIntoChildren(_ values: [TDataCore], at indexes: NSIndexSet)

    @objc(removeChildrenAtIndexes:)
    @NSManaged public func removeFromChildren(at indexes: NSIndexSet)

    @objc(replaceObjectInChildrenAtIndex:withObject:)
    @NSManaged public func replaceChildren(at idx: Int, with value: TDataCore)

    @objc(replaceChildrenAtIndexes:withChildren:)
    @NSManaged public func replaceChildren(at indexes: NSIndexSet, with values: [TDataCore])

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: TDataCore)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: TDataCore)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSOrderedSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSOrderedSet)

}

// MARK: Generated accessors for parents
extension TDataCore {

    @objc(insertObject:inParentsAtIndex:)
    @NSManaged public func insertIntoParents(_ value: TDataCore, at idx: Int)

    @objc(removeObjectFromParentsAtIndex:)
    @NSManaged public func removeFromParents(at idx: Int)

    @objc(insertParents:atIndexes:)
    @NSManaged public func insertIntoParents(_ values: [TDataCore], at indexes: NSIndexSet)

    @objc(removeParentsAtIndexes:)
    @NSManaged public func removeFromParents(at indexes: NSIndexSet)

    @objc(replaceObjectInParentsAtIndex:withObject:)
    @NSManaged public func replaceParents(at idx: Int, with value: TDataCore)

    @objc(replaceParentsAtIndexes:withParents:)
    @NSManaged public func replaceParents(at indexes: NSIndexSet, with values: [TDataCore])

    @objc(addParentsObject:)
    @NSManaged public func addToParents(_ value: TDataCore)

    @objc(removeParentsObject:)
    @NSManaged public func removeFromParents(_ value: TDataCore)

    @objc(addParents:)
    @NSManaged public func addToParents(_ values: NSOrderedSet)

    @objc(removeParents:)
    @NSManaged public func removeFromParents(_ values: NSOrderedSet)

}

extension TDataCore : Identifiable {

}
