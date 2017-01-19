//
// Copyright (C) 2016-present Instructure, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
    
    

import Foundation
import CoreData

extension Notification {
    
    func objectsForKey(_ key: String) -> Set<NSManagedObject> {
        return (userInfo?[key] as? Set<NSManagedObject>) ?? Set()
    }
    
    public var insertedObjects: Set<NSManagedObject> {
        return objectsForKey(NSInsertedObjectsKey)
    }
    
    public var updatedObjects: Set<NSManagedObject> {
        return objectsForKey(NSUpdatedObjectsKey)
    }
    
    public var deletedObjects: Set<NSManagedObject> {
        return objectsForKey(NSDeletedObjectsKey)
    }
    
    public var refreshedObjects: Set<NSManagedObject> {
        return objectsForKey(NSRefreshedObjectsKey)
    }
    
    public var invalidatedObjects: Set<NSManagedObject> {
        return objectsForKey(NSInvalidatedObjectsKey)
    }
    
    public var invalidatedAllObjects: Bool {
        return userInfo?[NSInvalidatedAllObjectsKey] != nil
    }
}


public enum ManagedObjectChange {
    case insert
    case delete
    case update
}

import ReactiveSwift
import Result

public final class ManagedObjectObserver<Object: NSManagedObject> {
    
    fileprivate let predicate: NSPredicate
    fileprivate let context: NSManagedObjectContext
    fileprivate (set) public var object: Object?
    fileprivate var token: NSObjectProtocol! = nil
    
    public let signal: Signal<(ManagedObjectChange, Object?), NoError>
    fileprivate let observer: Observer<(ManagedObjectChange, Object?), NoError>
    
    public init(predicate: NSPredicate, inContext context: NSManagedObjectContext) throws {
        self.predicate = predicate
        self.context = context
        
        let sig: Signal<(ManagedObjectChange, Object?), NoError>
        (sig, observer) = Signal.pipe()
        self.signal = sig.observe(on: UIScheduler())
        
        token = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context, queue: nil) { [unowned self] note in
            guard let changeType = self.changeTypeOfObject(note) else { return }
            self.observer.send(value: (changeType, self.object))
        }

        let request: NSFetchRequest<Object> = context.fetch(predicate, sortDescriptors: nil)
        object = (try context.fetch(request)).first
    }
    
    deinit {
        NotificationCenter.default.removeObserver(token)
    }
    
    fileprivate func changeTypeOfObject(_ note: Notification) -> ManagedObjectChange? {
        for inserted in note.insertedObjects {
            guard let insertedModel = inserted as? Object, predicate.evaluate(with: insertedModel) else { continue }
            
            object = insertedModel
            return .insert
        }
        
        guard let object = self.object else { return nil }

        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        if note.invalidatedAllObjects || (deleted.contains { $0 === self.object }) {
            return .delete
        }
        let updated = note.updatedObjects.union(note.refreshedObjects)
        if (updated.contains { $0 === object }) {
            return .update
        }
        return nil
    }
}
