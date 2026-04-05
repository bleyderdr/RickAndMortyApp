//
//  NSCacheStore.swift
//  RickAndMortyApp
//
//  Created by Bladimir Salinas on 28/03/26.
//

import Foundation

protocol NSCacheStoreDatasource {
    associatedtype Key: Hashable
    associatedtype Value
    
    func save(_ value: Value, forKey key: Key)
    func retrieve(forKey key: Key) -> Value?
    func removeValue(forKey key: Key)
    subscript(key: Key) -> Value? { get set }
    
}

class DefaultNSCacheStoreDatasource <Key: Hashable, Value>: NSCacheStoreDatasource {
    
    private let wrapped = NSCache<WrapppedKey, Entry>()
    
    func save(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: WrapppedKey(key: key))
    }
    
    func retrieve(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrapppedKey(key: key))
        return entry?.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrapppedKey(key: key))
    }
    
    subscript(key: Key) -> Value? {
        get {
            return retrieve(forKey: key)
        }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            save(value, forKey: key)
        }
    }
    
    
}

private extension DefaultNSCacheStoreDatasource {
    final class WrapppedKey: NSObject {
        let key: Key
        
        init(key: Key) {
            self.key = key
        }
        override var hash: Int {
            return key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool{
            guard let value = object as? WrapppedKey else {
                return false
            }
            return value.key == key
            
        }
    }
}

private extension DefaultNSCacheStoreDatasource {
    final class Entry {
        let value: Value
        
        init(value: Value) {
            self.value = value
        }
    }
}
