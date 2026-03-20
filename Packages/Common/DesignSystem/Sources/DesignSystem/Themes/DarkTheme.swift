//
//  DarkTheme.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.02.2026.
//

import SwiftUI

public struct DarkTheme: AppTheme {

    public init() {}

    public let scheme: ThemeScheme = .dark

    public let colors = DSColors(
        // MARK: - Text

        textPrimary: .white.opacity(0.95),
        textSecondary: Color("A1A4AA"),
        textDisabled: Color("6E7177"),
        textError: Color("FF3B30"),

        // MARK: - Backgrounds

        appBackground: Color("0F1114"),
        cardBackground: Color("1C1E22"),
        loginBackground: Color("621E46"),
        surfaceSecondary: Color("181A1E"),

        // MARK: - Separators

        divider: Color("2A2C31"),

        // MARK: - Controls

        iconSecondary: .white.opacity(0.55),
        switchOn: Color("0A84FF"),
        switchOff: Color("3A3C41"),

        // MARK: - Accent

        accent: Color("0A84FF"),

        // MARK: - Material helpers

        materialBorder: .white.opacity(0.08),

        // MARK: - Text Field

        textFieldBorder: Color("2A2C31"),
        textFieldBorderFocused: Color("0A84FF"),
        textFieldBorderError: Color("FF453A"),

        textFieldBackground: Color("181A1E"),
        textFieldBackgroundDisabled: Color.white.opacity(0.04),

        // MARK: - Buttons

        buttonPrimaryBackground: Color("0A84FF"),
        buttonPrimaryForeground: .white,

        buttonPrimaryDisabledBackground: Color.white.opacity(0.08),
        buttonPrimaryDisabledForeground: .white.opacity(0.4),

        // MARK: - badges
        badgeActive: Color.green.opacity(0.85),
        badgeCredit: Color.red.opacity(0.85),
        badgeInactive: Color.blue.opacity(0.85),
        badgeWarning: Color.yellow.opacity(0.85),

        badgeTextOnColor: .white,

        // MARK: - Chips
        chipBackground: Color("23262C"),
        chipBorder: Color("2A2C31"),
        chipText: .white.opacity(0.95),
        secondaryChipText: .black.opacity(0.95),

        chipSelectedBackground: Color("0A84FF"),
        chipSelectedBorder: Color("0A84FF"),
        chipSelectedText: .white,

        //MARK: Login
        backgroundSecondary: Color.gray.opacity(0.2),
        buttonDisabled: Color.gray.opacity(0.5),
        loadingOverlay: Color.black.opacity(0.5)
    )

    public let typography = DSTypography(
        largeTitle: .largeTitle,

        screenTitle: .title.weight(.semibold),

        sectionTitle: .title3.weight(.semibold),
        cardTitle: .body.weight(.semibold),

        body: .body,
        secondary: .subheadline,
        caption: .footnote,

        button: .callout.weight(.medium),
        label: .footnote.weight(.medium),
        input: .body,
        error: .footnote.weight(.semibold)
    )

    public let layout = DSLayout(
        spacing: DSSpacing(
            xxs: 2,
            xs: 4,
            s: 8,
            sm: 12,
            m: 16,
            ml: 24,
            l: 32,
            xl: 48,
            xxl: 64
        ),
        cornerRadius: DSCornerRadius(
            xs: 4,
            s: 8,
            m: 14,
            l: 16
        )
    )
}
