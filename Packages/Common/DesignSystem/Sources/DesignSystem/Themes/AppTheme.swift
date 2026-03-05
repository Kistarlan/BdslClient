//
//  AppTheme.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.02.2026.
//

import SwiftUI

public protocol AppTheme {
    var scheme: ThemeScheme { get }
    var colors: DSColors { get }
    var typography: DSTypography { get }
    var layout: DSLayout { get }
}
