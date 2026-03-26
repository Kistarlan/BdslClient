//
//  Cache.swift
//  Services
//
//  Created by Oleh Rozkvas on 04.03.2026.
//

public actor Cache<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]

    public init() {}

    public subscript(key: Key) -> Value? {
        get { storage[key] }
        set { storage[key] = newValue }
    }

    public func get(key: Key) -> Value? {
        storage[key]
    }

    public func remove(forKey key: Key) {
        storage.removeValue(forKey: key)
    }

    public func add(key: Key, value: Value) {
        storage[key] = value
    }

    public func clear() {
        storage.removeAll()
    }

    public func getAll() -> [Value] {
        storage.map { $0.value }
    }

    public func getAllKeys() -> [Key] {
        storage.map { $0.key }
    }

    public var isEmpty: Bool {
        storage.count == 0
    }

    public var isNotEmpty: Bool {
        !isEmpty
    }
}
