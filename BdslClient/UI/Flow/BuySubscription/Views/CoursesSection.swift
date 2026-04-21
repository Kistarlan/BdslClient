//
//  CoursesSection.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 21.04.2026.
//

import DesignSystem
import SwiftUI

struct CoursesSection: View {
    var viewModel: BuySubscriptionViewModel

    var body: some View {
        SubscriptionSelectionSection(title: .courses) {
            ForEach(viewModel.displayedCourses, id: \.id) { course in
                FilterChip(
                    title: course.title,
                    isSelected: viewModel.selectedCourseIds.contains(course.id)
                ) {
                    viewModel.toggleCourse(course.id)
                }
            }
        }
        .redacted(reason: !viewModel.isInitialized ? .placeholder : [])
        .shimmer(active: !viewModel.isInitialized)
        .disabled(!viewModel.isInitialized)
    }
}
