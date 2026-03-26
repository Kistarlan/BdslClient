//
//  Filter.swift
//  Models
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

import Foundation

public enum Filter {
    // MARK: - In filters

    public static func In(_ field: String, _ ids: [String]) -> MongoFilter {
        InFilter(field: field, values: ids)
    }

    public static func userIn(_ ids: [String]) -> MongoFilter {
        In("user", ids)
    }

    // MARK: - gt filters

    public static func GreaterThanOrEqual<Value: Encodable>(_ field: String, _ value: Value) -> MongoFilter {
        GteFilter(field: field, value: value)
    }

    public static func createdAfter(_ date: Date) -> MongoFilter {
        GreaterThanOrEqual("createdAt", date)
    }

    public static func GreaterThan<Value: Encodable>(_ field: String, _ value: Value) -> MongoFilter {
        GtFilter(field: field, value: value)
    }

    // MARK: - lte filters

    public static func LowerThanOrEqual<Value: Encodable>(_ field: String, _ value: Value) -> MongoFilter {
        LteFilter(field: field, value: value)
    }

    // MARK: - or filters

    public static func or(_ filters: MongoFilter...) -> MongoFilter {
        OrFilter(filters: filters)
    }

    // MARK: - nin filters(not in)

    public static func nin<Value: Encodable>(_ field: String, _ values: [Value]) -> MongoFilter {
        NinFilter(field: field, values: values)
    }

    // MARK: - and filters(not in)

    public static func and(_ filters: MongoFilter...) -> MongoFilter {
        AndFilter(filters: filters)
    }
}
