//
//  EditUserInfoView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 12.02.2026.
//

import PhotosUI
import SwiftUI
import Models
import DesignSystem
import Navigation

struct EditUserInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme
    @Environment(Router.self) private var router

    @State private var viewModel: EditUserInfoViewModel
    @FocusState private var focusedField: EditUserInfoField?

    @State private var selectedPhotoItem: PhotosPickerItem?

    var avatarImage: UIImage? {
        guard let avatarData = viewModel.avatarData else { return nil }
        return UIImage(data: avatarData)
    }

    var isSaveEnabled: Bool {
        viewModel.isSaveEnabled && !viewModel.isLoading
    }

    init(viewModel: EditUserInfoViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: theme.layout.spacing.l) {
                    avatarSection

                    inputSection

                    saveButton

                    if viewModel.isLoading {
                        loadingView
                    }
                }
                .padding(theme.layout.spacing.l)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

private extension EditUserInfoView {
    private var avatarSection: some View {
        VStack(spacing: theme.layout.spacing.m) {
            ZStack {
                Circle()
                    .fill(theme.colors.cardBackground)
                    .frame(width: 120, height: 120)

                if let image = avatarImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 120, height: 120)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 96, height: 96)
                        .foregroundColor(theme.colors.iconSecondary)
                        .clipShape(Circle())
                }
            }
//TODO: implement when it will be available in API
//            changeAvatarButton
        }
    }

    private var changeAvatarButton: some View {
        Button {
            viewModel.showSourceDialog = true
        } label: {
            Text(.changeAvatar)
                .fontWeight(.bold)
                .foregroundColor(theme.colors.accent)
        }
        .confirmationDialog(.selectSource, isPresented: $viewModel.showSourceDialog) {
            Button(.camera) { viewModel.showCamera = true }
            Button(.photoLibrary) { viewModel.showPhotoPicker = true }
            Button(.cancel, role: .cancel) { viewModel.showSourceDialog = false }
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    await viewModel.setAvatar(data)
                }
            }
        }
        .photosPicker(
            isPresented: $viewModel.showPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images
        )
        .fullScreenCover(isPresented: $viewModel.showCamera) {
            ZStack {
                Color.black.ignoresSafeArea()

                ImagePicker(sourceType: .camera) { data in
                    Task {
                        await viewModel.setAvatar(data)
                    }
                }
                .ignoresSafeArea()
            }
        }
    }

    private var inputSection: some View {
        VStack(spacing: theme.layout.spacing.m) {
            CustomTextField(
                title: .name,
                text: $viewModel.name,
                error: viewModel.nameError
            )
            .focused($focusedField, equals: .name)

            CustomTextField(
                title: .surname,
                text: $viewModel.surname,
                error: viewModel.surnameError
            )
            .focused($focusedField, equals: .name)

            CustomTextField(
                title: .phone,
                text: $viewModel.phone,
                error: viewModel.phoneError,
                prefix: "+38 "
            )
            .focused($focusedField, equals: .phone)


            CustomTextField(
                title: .email,
                text: $viewModel.email,
                keyboardType: .emailAddress,
                error: viewModel.emailError
            )
            .focused($focusedField, equals: .email)
        }
        .onChange(of: focusedField) { old, _ in
            if let old {
                viewModel.fieldDidLoseFocus(old)
            }
        }
    }

    private var saveButton: some View {
        Button {
            Task {
                if await viewModel.save() {
                    router.pop(result: viewModel.user)
                }
            }
        } label: {
            Text(.save)
                .frame(maxWidth: .infinity)
                .padding(theme.layout.spacing.m)
                .background(
                    viewModel.isSaveEnabled
                    ? theme.colors.buttonPrimaryBackground
                    : theme.colors.buttonPrimaryDisabledBackground
                )
                .foregroundColor(
                    viewModel.isSaveEnabled
                    ? theme.colors.buttonPrimaryForeground
                    : theme.colors.buttonPrimaryDisabledForeground
                )
                .cornerRadius(theme.layout.cornerRadius.l)
        }
        .disabled(!isSaveEnabled)
        .opacity(isSaveEnabled ? 1 : 0.6)
        .animation(.easeInOut(duration: 0.2), value: isSaveEnabled)
    }

    private var loadingView: some View {
        VStack(spacing: theme.layout.spacing.s) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.accent))
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        EditUserInfoView(viewModel: AppContainer.shared.viewModelsFactory
            .makeEditUserInfoViewModel(user: UserDTO.previewValue().toDomain()))
    }
    .setupPreviewEnvironments(.light)
}
