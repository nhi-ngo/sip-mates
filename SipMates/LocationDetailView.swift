//
//  LocationDetailView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI

struct LocationDetailView: View {
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image("default-banner-asset")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                
                HStack() {
                    Label("123 Main Street", systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()

                }
                .padding(.horizontal)
                
                Text("This is a text description. This is a text description. This is a text description. This is a text description.")
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)
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
                        
                        Link(destination: URL(string: "https://www.apple.com")!, label: {
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
                
                LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 3), content: {
                    FirstNameAvatarView(firstName: "Nhi")
                    FirstNameAvatarView(firstName: "Swift")
                    FirstNameAvatarView(firstName: "NiceniceniceNicenicenice")
                    FirstNameAvatarView(firstName: "Swift")
                    FirstNameAvatarView(firstName: "Swift")
                    FirstNameAvatarView(firstName: "Swift")
                })
                
                Spacer()
                
            }
            .navigationTitle("Location")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LocationDetailView()
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
