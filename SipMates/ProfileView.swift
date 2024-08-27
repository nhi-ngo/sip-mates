//
//  ProfileView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var companyName = ""
    @State private var bio = ""
    
    var body: some View {
        VStack {
            ZStack {
                Color(.secondarySystemBackground)
                    .frame(height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack(spacing: 15) {
                    ZStack {
                        AvatarView(size: 84)
                        
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.white)
                            .offset(y: 30)
                    }
                    
                    VStack(spacing: 1) {
                        TextField("First Name", text: $firstName)
                            .font(.system(size: 32, weight: .bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                        
                        TextField("Last Name", text: $lastName)
                            .font(.system(size: 26, weight: .semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                        
                        TextField("Company Name", text: $companyName)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .padding(.horizontal)
            
            VStack(spacing: 8) {
                HStack {
                    Text("Bio: ")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    +
                    Text("\(100 - bio.count)")
                        .bold()
                        .font(.callout)
                        .foregroundStyle(.brandPrimary)
                    +
                    Text(" characters remain")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "mappin.and.ellipse")
                    Text("Check Out")
                }
                
                TextEditor(text: $bio)
                    .disabled(100 - bio.count == 0)
                    .frame(height: 100)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1))
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Text("Create Profile")
                        .bold()
                        .frame(width: 280, height: 44)
                        .background(.brandPrimary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                })
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
