//
//  ProfileView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI
import PhotosUI
import CloudKit

@MainActor
struct ProfileView: View {
    
    @State private var viewModel = ProfileViewModel()
    @FocusState private var focusedTextField: ProfileTextField?
    
    enum ProfileTextField {
        case firstName, lastName, companyName, bio
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    ProfileImageView(viewModel: viewModel)
                    
                    VStack(spacing: 1) {
                        TextField("First Name", text: $viewModel.firstName)
                            .profileNameStyle()
                            .focused($focusedTextField, equals: .firstName)
                            .onSubmit { focusedTextField = .lastName }
                            .submitLabel(.next)
                        
                        TextField("Last Name", text: $viewModel.lastName)
                            .profileNameStyle()
                            .focused($focusedTextField, equals: .lastName)
                            .onSubmit { focusedTextField = .companyName }
                            .submitLabel(.next)
                        
                        TextField("Company Name", text: $viewModel.companyName)
                            .focused($focusedTextField, equals: .companyName)
                            .onSubmit { focusedTextField = .bio }
                            .submitLabel(.next)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.vertical)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(spacing: 8) {
                    HStack {
                        CharactersRemainView(currentCount: viewModel.bio.count)
                        
                        Spacer()
                        
                        if viewModel.isCheckedIn {
                            Button {
                                viewModel.checkOut()
                            } label: {
                                CheckOutButton()
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }
                    
                    TextField("Enter your bio", text: $viewModel.bio, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(4...6)
                        .focused($focusedTextField, equals: .bio)
                }
                .padding()
                
                Spacer()
                
                Button {
                    viewModel.determineButtonAction()
                } label: {
                    SMButton(title: viewModel.buttonTitle)
                }
                .padding(.bottom)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Dismiss") { focusedTextField = nil }
                }
            }
            
            if viewModel.isLoading { LoadingView() }
        }
        .navigationTitle("Profile")
        .ignoresSafeArea(.keyboard)
        .task {
            viewModel.getProfile()
            viewModel.getCheckedInStatus()
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}

struct ProfileImageView: View {
    var viewModel: ProfileView.ProfileViewModel
    @State private var selectedImage: PhotosPickerItem?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AvatarView(size: 84, image: viewModel.avatar)
            
            PhotosPicker(selection: $selectedImage, matching: .images) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(.white)
                    .padding(.bottom, 5)
            }
        }
        .padding(.leading, 12)
        .onChange(of: selectedImage) { _, _ in
            Task {
                if let pickerItem = selectedImage,
                   let data = try? await pickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        viewModel.avatar = image
                    }
                }
            }
        }
    }
}

struct ProfileNameStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 26, weight: .semibold))
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
}

extension View {
    func profileNameStyle() -> some View {
        modifier(ProfileNameStyle())
    }
}

struct CharactersRemainView: View {
    var currentCount: Int
    
    var body: some View {
        
        Text("Bio: ")
            .font(.callout)
            .foregroundStyle(.secondary)
        +
        Text("\(100 - currentCount)")
            .bold()
            .font(.callout)
            .foregroundStyle(.brandPrimary)
        +
        Text(" characters remain")
            .font(.callout)
            .foregroundStyle(.secondary)
    }
}

struct CheckOutButton: View {
    var body: some View {
        Label("Check Out", systemImage: "mappin.and.ellipse")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.white)
            .padding(10)
            .frame(height: 28)
            .background(.red)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
