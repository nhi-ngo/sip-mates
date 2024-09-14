//
//  ProfileView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @State private var viewModel = ProfileViewModel()
    
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
                    ProfileImageView(viewModel: viewModel)
                    
                    VStack(spacing: 1) {
                        TextField("First Name", text: $firstName)
                            .profileNameStyle()
                        
                        TextField("Last Name", text: $lastName)
                            .profileNameStyle()
                        
                        TextField("Company Name", text: $companyName)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .padding(.horizontal)
            
            VStack(spacing: 8) {
                CharactersRemainView(currentCount: bio.count)
                
                TextEditor(text: $bio)
                    .disabled(100 - bio.count == 0)
                    .frame(height: 100)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1))
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    SMButton(title: "Create Profile")
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

struct ProfileImageView: View {
    var viewModel: ProfileViewModel
    @State private var selectedImage: PhotosPickerItem?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AvatarView(size: 84, image: viewModel.avatar)
            
            PhotosPicker(selection: $selectedImage, matching: .images) {
                EditImage()
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

struct EditImage: View {
    var body: some View {
        Image(systemName: "square.and.pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 14, height: 14)
            .foregroundStyle(.white)
            .padding(.bottom, 5)
    }
}

struct CharactersRemainView: View {
    var currentCount: Int
    
    var body: some View {
        HStack {
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
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Image(systemName: "mappin.and.ellipse")
            Text("Check Out")
        }
    }
}
