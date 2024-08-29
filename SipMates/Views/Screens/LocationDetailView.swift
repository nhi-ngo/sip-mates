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
            Image("default-banner-asset")
                .resizable()
                .scaledToFill()
                .frame(height: 120)
            
            HStack() {
                Label(location.address, systemImage: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
            }
            .padding(.horizontal)
            
            Text(location.description)
                .lineLimit(3)
                .minimumScaleFactor(0.75)
                .frame(height: 70)
                .padding(.horizontal)
            
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
            AvatarView(size: 64)
            
            Text(firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}
