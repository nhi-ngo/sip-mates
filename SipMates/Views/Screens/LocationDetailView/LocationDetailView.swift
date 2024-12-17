//
//  LocationDetailView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI

struct LocationDetailView: View {
    
    @Bindable var viewModel: LocationDetailViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                BannerImageView(image: viewModel.location.bannerImage)
                AddressHStack(address: viewModel.location.address)
                DescriptionView(text: viewModel.location.description)
                ActionButtonHStack(viewModel: viewModel)
                Text("Who's Here?").bold().font(.title2)
                AvatarGridView(viewModel: viewModel)
                Spacer()
            }
            
            if viewModel.isShowingProfileModal {
                Color(.black).ignoresSafeArea().opacity(0.9)
                ProfileModalView(profile: viewModel.selectedProfile!,
                                 isShowingProfileModal: $viewModel.isShowingProfileModal)
            }
        }
        .task {
            viewModel.getCheckedInProfiles()
            viewModel.getCheckedInStatus()
        }
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $viewModel.alertItem, content: { $0.alert })
    }
}

#Preview {
    NavigationStack {
        LocationDetailView(viewModel: LocationDetailViewModel(location: SMLocation(record: MockData.location)))
    }
}

struct LocationActionButton: View {
    var color: Color = .brandPrimary
    var imageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(color)
                .frame(width: 60, height: 60)
            
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 22, height: 22)
        }
    }
}

struct FirstNameAvatarView: View {
    var profile: SMProfile
    
    var body: some View {
        VStack {
            AvatarView(size: 64, image: profile.avatarImage)
            
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

struct BannerImageView: View {
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
    }
}

struct AddressHStack: View {
    var address: String
    
    var body: some View {
        HStack {
            Label(address, systemImage: "mappin.and.ellipse")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct DescriptionView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .frame(height: 70)
            .padding(.horizontal)
    }
}

struct ActionButtonHStack: View {
    var viewModel: LocationDetailViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                viewModel.getDirectionsToLocation()
            }, label: {
                LocationActionButton(imageName: "location.fill")
            })
            
            Link(destination: URL(string: viewModel.location.websiteURL)!, label: {
                LocationActionButton(imageName: "network")
            })
            
            Button(action: {
                viewModel.callLocation()
            }, label: {
                LocationActionButton(imageName: "phone.fill")
            })
            
            if let _ = CloudKitManager.shared.profileRecordID {
                Button(action: {
                    viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
                }, label: {
                    LocationActionButton(color: viewModel.checkInButtonColor, imageName: viewModel.checkInButtonImage)
                })
                .disabled(viewModel.isLoading)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background(Color(.secondarySystemBackground))
        .clipShape(Capsule())
    }
}

struct AvatarGridView: View {
    var viewModel: LocationDetailViewModel
    
    var body: some View {
        ZStack {
            if viewModel.checkedInProfiles.isEmpty {
                ContentUnavailableView("Nobody's Here", systemImage: "person.slash", description: Text("Nobody has checked in yet."))
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 3), content: {
                        ForEach(viewModel.checkedInProfiles) { profile in
                            FirstNameAvatarView(profile: profile)
                                .onTapGesture {
                                    withAnimation { viewModel.show(profile) }
                                }
                        }
                    })
                }
            }
        }
    }
}
