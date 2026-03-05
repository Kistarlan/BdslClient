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

    public init(key: Key, items: [Item]) {
        self.key = key
        self.items = items
    }
}

extension Array {
    public func grouped<Key: Hashable>(
        by keyPath: KeyPath<Element, Key>
    ) -> [GroupedSection<Key, Element>] {
        Dictionary(grouping: self, by: { $0[keyPath: keyPath] })
            .map { GroupedSection(key: $0.key, items: $0.value) }
    }
}

extension Sequence {
    public func grouped<Key: Hashable>(
        by keyPath: KeyPath<Element, Key>
    ) -> [GroupedSection<Key, Element>] {
        grouped { $0[keyPath: keyPath] }
    }

    public func grouped<Key: Hashable>(
        by keySelector: (Element) -> Key
    ) -> [GroupedSection<Key, Element>] {

        Dictionary(grouping: self, by: keySelector)
            .map { GroupedSection(key: $0.key, items: $0.value) }
    }
}
