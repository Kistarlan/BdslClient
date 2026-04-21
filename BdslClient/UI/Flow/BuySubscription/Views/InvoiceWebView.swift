//
//  InvoiceWebView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 21.04.2026.
//

import SafariServices
import SwiftUI

struct InvoiceWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
