//
//  AttendeesScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 24.02.2026.
//

import SwiftUI
import Models
import DesignSystem

struct AttendeesScreen: View {
    @Environment(\.theme) private var theme
    @Bindable private var viewModel: AttendeesViewModel

    var displayedAttendees: [AttendeeModel] {
        if viewModel.isLoading {
            return (0..<5).map { _ in .placeholder() }
        }

        return viewModel.attendees
    }

    init(attendeesViewModel: AttendeesViewModel) {
        self.viewModel = attendeesViewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: theme.layout.spacing.l) {

                SubscriptionDetailCard(subscription: viewModel.userSubscription)

                if displayedAttendees.isEmpty {
                    emptyStateView
                } else {
                    attendeesSection
                }
            }
            .padding(theme.layout.spacing.m)
        }
        .background(theme.colors.appBackground)
        .navigationTitle(LocalizedStringResource.subscriptionDetails)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.fetchAttendees()
        }
    }

    var attendeesSection: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.m) {

            HStack {
                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        Text(.visits)
                            .font(theme.typography.sectionTitle)
                            .foregroundColor(theme.colors.textPrimary)

                        Text(": ")
                            .font(theme.typography.sectionTitle)
                            .foregroundColor(theme.colors.textPrimary)
                    }
                    Spacer()
                }

                if let badgeLessonsCount = viewModel.userSubscription.badgeLessonsCount {
                    VStack {
                        Spacer()
                        RemainingCircle(
                            badgeLessonsCount: badgeLessonsCount,
                            category: viewModel.userSubscription.category
                        )
                        Spacer()
                    }
                }
            }

            LazyVStack(spacing: theme.layout.spacing.sm) {
                ForEach(displayedAttendees) { attendee in
                    AttendeeCard(attendee: attendee)
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                        .shimmer(active: viewModel.isLoading)
                }
            }
        }
    }

    var emptyStateView: some View {
        VStack(spacing: theme.layout.spacing.m) {
            Image(systemName: "person.3")
                .font(.system(size: 40))
                .foregroundColor(theme.colors.textSecondary)

            Text(.noVisitsYet)
                .font(theme.typography.sectionTitle)
                .foregroundColor(theme.colors.textPrimary)

            Text(.noVisitsYetDescription)
                .font(theme.typography.body)
                .foregroundColor(theme.colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(theme.layout.spacing.xl)
    }
}
