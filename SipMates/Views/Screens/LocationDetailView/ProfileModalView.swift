//
//  ProfileModalView.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/19/24.
//

import SwiftUI

struct ProfileModalView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 60)
                Text("Full Name")
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                
                Text("Company")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundStyle(.secondary)
                
                Text("Sample Bio.Sample Bio.Sample Bio.Sample Bio.Sample Bio.Sample Bio.Sample Bio.Sample Bio.Sample Bio.")
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)
                    .padding()
            }
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .overlay(alignment: .topTrailing) {
                Button(action: {}, label: {
                    XDismissButton()
                })
            }
            
            Image(uiImage: PlaceholderImage.avatar)
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
    ProfileModalView()
}
