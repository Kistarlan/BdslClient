//
//  BasicStateView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//

import SwiftUI
import Models

public struct BasicStateView<ViewData, LoadingContent: View, DataContent: View>: View {
    let state: BasicLoadingState<ViewData>
    let loadingContent: () -> LoadingContent
    let dataContent: (ViewData) -> DataContent
    let retry: () -> Void

    public var body: some View {
        Group {
            switch state {
            case .idle, .loading:
                loadingContent().disabled(true)

            case let .dataLoaded(data):
                dataContent(data)

            case let .error(error):
                ContentUnavailableView {
                    Label("Error", systemImage: "xmark")
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Retry", action: retry)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
