//
//  Router.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 27.01.2026.
//

import OSLog
import SwiftUI

@Observable
public final class Router {
    public let id = UUID()
    public let level: Int

    /// Only relevant for the `level 0` root router. Defines the tab to select
    public var selectedTab: TabDestination?

    /// Values presented in the navigation stack
    public var navigationStackPath: [PushDestination] = []
    public var popResults: [PushDestination: AnyHashable] = [:]

    /// Current presented sheet
    public var presentingSheet: SheetDestination?

    /// Current presented full screen
    public var presentingFullScreen: FullScreenDestination?

    public let logger = Logger.forCategory("Navigation")

    /// Reference to the parent router to form a hierarchy
    /// Router levels increase for the children
    weak var parent: Router?

    /// Child routers cached by tab
    private var childRouters: [Destination: Router] = [:]
    /// A way to track which router is visible/active
    /// Used for deep link resolution
    private(set) var isActive: Bool = false

    public init(level: Int, identifierDestination: Destination?) {
        self.level = level
        self.parent = nil

        logger.debug("\(self.debugDescription) initialized")
    }

    deinit {
        logger.debug("\(self.debugDescription) cleared")
    }

    private func resetContent() {
        navigationStackPath = []
        popResults = [:]
        presentingSheet = nil
        presentingFullScreen = nil
    }
}

// MARK: - Router Management

extension Router {
    public func childRouter(for destination: Destination) -> Router {
        if let existing = childRouters[destination] { return existing }

        let router = Router(level: level + 1, identifierDestination: destination)
        router.parent = self
        childRouters[destination] = router
        return router
    }

    public func setActive() {
        logger.debug("\(self.debugDescription): \(#function)")
        parent?.resignActive()
        isActive = true
    }

    public func resignActive() {
        logger.debug("\(self.debugDescription): \(#function)")
        isActive = false
        parent?.setActive()
    }

    public static func previewRouter() -> Router {
        Router(level: 0, identifierDestination: nil)
    }
}

// MARK: - Navigation

extension Router {
    public func navigate(to destination: Destination) {
        switch destination {
        case let .tab(tab):
            select(tab: tab)

        case let .push(destination):
            push(destination)

        case let .sheet(destination):
            present(sheet: destination)

        case let .fullScreen(destination):
            present(fullScreen: destination)
        }
    }

    public func select(tab destination: TabDestination) {
        logger.debug("\(self.debugDescription) \(#function) \(destination.rawValue)")
        if level == 0 {
            selectedTab = destination
        } else {
            parent?.select(tab: destination)
            resetContent()
        }
    }

    public func push(_ destination: PushDestination) {
        logger.debug("\(self.debugDescription): \(#function) \(destination)")
        navigationStackPath.append(destination)
    }

    public func present(sheet destination: SheetDestination) {
        logger.debug("\(self.debugDescription): \(#function) \(destination)")
        presentingSheet = destination
    }

    public func present(fullScreen destination: FullScreenDestination) {
        logger.debug("\(self.debugDescription): \(#function) \(destination)")
        presentingFullScreen = destination
    }

    public func deepLinkOpen(to destination: Destination) {
        guard isActive else { return }

        logger.debug("\(self.debugDescription): \(#function) \(destination)")
        navigate(to: destination)
    }
}

extension Router {
    public func pop(destination: PushDestination? = nil) {
        pop(destination: destination, result: Optional<Never>.none)
    }

    public func pop<T: Hashable>(
        destination: PushDestination? = nil,
        result: T?
    ) {
        if let pushDestination = destination {
            if let index = navigationStackPath.lastIndex(of: pushDestination) {
                navigationStackPath.remove(at: index)
            }

            if let result {
                popResults[pushDestination] = result
            }
        } else if let lastDestination = navigationStackPath.last {
            navigationStackPath.removeLast()

            if let result {
                popResults[lastDestination] = result
            }
        }
    }
    public func consumePopResult<T: Hashable>(for destination: PushDestination?) -> T? {
        if let pushDestination = destination {
            return popResults.removeValue(forKey: pushDestination) as? T
        }

        return popResults.remove(at: popResults.startIndex) as? T
    }
}

extension Router: CustomDebugStringConvertible {
    public nonisolated var debugDescription: String {
        "Router[\(shortId) - Level: \(level)]"
    }

    private nonisolated var shortId: String { String(id.uuidString.split(separator: "-").first ?? "") }
}

