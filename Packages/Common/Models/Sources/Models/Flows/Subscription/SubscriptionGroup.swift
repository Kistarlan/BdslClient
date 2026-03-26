//
//  SubscriptionGroup.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.02.2026.
//

public struct GroupedSection<Key: Hashable & Comparable, Item>: Identifiable {
    public let key: Key
    public let items: [Item]

    public var id: Key { key }

    public init(_ key: Key, _ items: [Item]) {
        self.key = key
        self.items = items
    }
}

public extension Array {
    func grouped<Key: Hashable>(
        by keyPath: KeyPath<Element, Key>
    ) -> [GroupedSection<Key, Element>] {
        Dictionary(grouping: self, by: { $0[keyPath: keyPath] })
            .map { GroupedSection($0.key, $0.value) }
    }
}

public extension Sequence {
    func grouped<Key: Hashable>(
        by keyPath: KeyPath<Element, Key>
    ) -> [GroupedSection<Key, Element>] {
        grouped { $0[keyPath: keyPath] }
    }

    func grouped<Key: Hashable>(
        by keySelector: (Element) -> Key
    ) -> [GroupedSection<Key, Element>] {
        Dictionary(grouping: self, by: keySelector)
            .map { GroupedSection($0.key, $0.value) }
    }
}
