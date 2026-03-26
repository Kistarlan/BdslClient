//
//  AttendeesScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 24.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct AttendeesScreen: View {
    @Environment(\.theme) private var theme
    @Bindable private var viewModel: AttendeesViewModel

    var displayedAttendees: [AttendeeModel] {
        if viewModel.isLoading {
            return (0 ..< 5).map { _ in .placeholder() }
        }

        return viewModel.attendees
    }

    init(attendeesViewModel: AttendeesViewModel) {
        viewModel = attendeesViewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: theme.layout.spacing.l) {
                SubscriptionDetailCard(subscription: viewModel.userSubscription)

                attendeesHeaderSection

                if displayedAttendees.isEmpty {
                    emptyStateView
                } else {
                    attendeesList
                }
            }
            .padding(theme.layout.spacing.m)
        }
        .background(theme.colors.appBackground)
        .navigationTitle(LocalizedStringResource.subscriptionDetails)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.fetchAttendees(forceReload: false)
        }
    }

    var attendeesList: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.m) {
            LazyVStack(spacing: theme.layout.spacing.sm) {
                ForEach(displayedAttendees) { attendee in
                    AttendeeCard(attendee: attendee)
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                        .shimmer(active: viewModel.isLoading)
                }
            }
        }
    }

    var attendeesHeaderSection: some View {
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
                    SubscriptionRemainingCircle(
                        badgeLessonsCount: badgeLessonsCount,
                        userSubscription: viewModel.userSubscription
                    )
                    Spacer()
                }
            }

            Spacer()
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
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(theme.layout.spacing.xl)
    }
}
