//
//  ProfileModalView.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/19/24.
//

import SwiftUI

struct ProfileModalView: View {
    
    var profile: SMProfile
    @Binding var isShowingProfileModal: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 60)
                Text(profile.firstName + " " + profile.lastName)
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                
                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundStyle(.secondary)
                
                Text(profile.bio)
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)
                    .padding()
            }
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    withAnimation { isShowingProfileModal = false }
                }, label: {
                    XDismissButton()
                })
            }
            
            Image(uiImage: profile.avatarImage)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                .offset(y: -120)
        }
    }
}

#Preview {
    ProfileModalView(profile: SMProfile(record: MockData.profile),
                     isShowingProfileModal: .constant(false))
}
