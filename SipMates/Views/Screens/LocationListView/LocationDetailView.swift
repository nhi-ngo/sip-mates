//
//  LocationDetailView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI

struct LocationDetailView: View {
    
    var location: SMLocation
    
    var body: some View {
        VStack(spacing: 16) {
            BannerImageView(image: location.createBannerImage())
            
            HStack() {
                AddressView(address: location.address)
                Spacer()
            }
            .padding(.horizontal)
            
            DescriptionView(text: location.description)
            
            ZStack {
                Capsule()
                    .frame(height: 80)
                    .foregroundStyle(Color(.secondarySystemBackground))
                
                HStack(spacing: 20) {
                    Button(action: {
                        //TODO
                    }, label: {
                        LocationActionButton(imageName: "location.fill")
                    })
                    
                    Link(destination: URL(string: location.websiteURL)!, label: {
                        LocationActionButton(imageName: "network")
                    })
                    
                    Button(action: {
                        //TODO
                    }, label: {
                        LocationActionButton(imageName: "phone.fill")
                    })
                    
                    Button(action: {
                        //TODO
                    }, label: {
                        LocationActionButton(imageName: "person.fill.checkmark")
                    })
                }
            }
            .padding(.horizontal)
            
            Text("Who's Here?").bold().font(.title2)
            
            ScrollView {
                LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 3), content: {
                    FirstNameAvatarView(firstName: "Nhi")
                    FirstNameAvatarView(firstName: "Swift")
                    FirstNameAvatarView(firstName: "NiceniceniceNicenicenice")
                    FirstNameAvatarView(firstName: "Swift")
                    FirstNameAvatarView(firstName: "Swift")
                    FirstNameAvatarView(firstName: "Swift")
                })
            }
            
            Spacer()
        }
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LocationDetailView(location: SMLocation(record: MockData.location))
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
    var firstName: String
    
    var body: some View {
        VStack {
            AvatarView(size: 64, image: PlaceholderImage.avatar)
            
            Text(firstName)
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

struct AddressView: View {
    var address: String
    
    var body: some View {
        Label(address, systemImage: "mappin.and.ellipse")
            .font(.caption)
            .foregroundStyle(.secondary)
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
