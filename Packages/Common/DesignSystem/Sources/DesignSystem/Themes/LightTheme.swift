//
//  LightTheme.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.02.2026.
//

import SwiftUI

public struct LightTheme: AppTheme {

    public init() {}

    public let scheme: ThemeScheme = .light

    public let colors = DSColors(
        // MARK: - Text

        textPrimary: .black.opacity(0.9),
        textSecondary: Color("8C8C8C"),
        textDisabled: Color("9A9CA1"),
        textError: Color("D92D20"),

        // MARK: - Backgrounds

        appBackground: Color("EFEEF3"),
        cardBackground: Color("FFFFFF"),
        loginBackground: Color("621E46"),
        surfaceSecondary: Color("F0F1F3"),

        // MARK: - Separators

        divider: Color("EFEEF3"),

        // MARK: - Controls

        iconSecondary: .black.opacity(0.5),
        switchOn: Color("0A84FF"),
        switchOff: Color("D1D2D6"),

        // MARK: - Accent

        accent: Color("0A84FF"),

        // MARK: - Material helpers

        materialBorder: .black.opacity(0.05),

        textFieldBorder: Color("D1D2D6"),
        textFieldBorderFocused: Color("0A84FF"),
        textFieldBorderError: Color("FF3B30"),

        textFieldBackground: Color.white,
        textFieldBackgroundDisabled: Color("F2F2F7"),

        // MARK: - Buttons

        buttonPrimaryBackground: Color("0A84FF"),
        buttonPrimaryForeground: .white,

        buttonPrimaryDisabledBackground: Color("D1D2D6"),
        buttonPrimaryDisabledForeground: .white.opacity(0.7),

        // MARK: - badges
        badgeActive: Color.green.opacity(0.85),
        badgeCredit: Color.red.opacity(0.85),
        badgeInactive: Color.blue.opacity(0.85),
        badgeWarning: Color.yellow.opacity(0.85),

        badgeTextOnColor: .white,

        // MARK: - Chips
        chipBackground: Color("E0E1E3"),
        chipBorder: Color("D1D2D6"),
        chipText: .black.opacity(0.9),
        secondaryChipText: .black.opacity(0.95),

        chipSelectedBackground: Color("0A84FF"),
        chipSelectedBorder: Color("0A84FF"),
        chipSelectedText: .white,

        //MARK: Login
        backgroundSecondary: Color.white.opacity(0.1),
        buttonDisabled: Color.gray.opacity(0.3),
        loadingOverlay: Color.black.opacity(0.2),
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
