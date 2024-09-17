//
//  ProfileView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI
import PhotosUI
import CloudKit

struct ProfileView: View {
    
    @State private var viewModel = ProfileViewModel()
    @State private var formError: FormError = .invalidProfile
    @State private var isShowingAlert = false
    
    @FocusState private var dismissKeyboard: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Color(.secondarySystemBackground)
                    .frame(height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack(spacing: 15) {
                    ProfileImageView(viewModel: viewModel)
                    
                    VStack(spacing: 1) {
                        TextField("First Name", text: $viewModel.firstName)
                            .profileNameStyle()
                            .focused($dismissKeyboard)
                        
                        TextField("Last Name", text: $viewModel.lastName)
                            .profileNameStyle()
                            .focused($dismissKeyboard)
                        
                        TextField("Company Name", text: $viewModel.companyName)
                            .focused($dismissKeyboard)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .padding(.horizontal)
            
            VStack(spacing: 8) {
                CharactersRemainView(currentCount: viewModel.bio.count)
                
                TextEditor(text: $viewModel.bio)
                    .disabled(100 - viewModel.bio.count == 0)
                    .frame(height: 100)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1))
                    .focused($dismissKeyboard)
                
                Spacer()
                
                Button(action: {
                    createProfile()
                }, label: {
                    SMButton(title: "Create Profile")
                })
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    dismissKeyboard.toggle()
                }
            }
        }
        .onAppear { getProfile() }
        .alert(isPresented: $isShowingAlert, error: formError) { formError in
            // Action - OK button to dismiss
        } message: { fetchError in
            Text(fetchError.failureReason)
        }
        
    }
    
    func isProfileValid() -> Bool {
        guard !viewModel.firstName.isEmpty,
              !viewModel.lastName.isEmpty,
              !viewModel.companyName.isEmpty,
              !viewModel.bio.isEmpty,
              viewModel.avatar != PlaceholderImage.avatar,
              viewModel.bio.count <= 100 else { return false }
        
        return true
    }
    
    func createProfile() {
        guard isProfileValid() else {
            isShowingAlert = true
            formError = .invalidProfile
            return
        }
        
        // create CKRecord from profile view
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[SMProfile.kFirstName] = viewModel.firstName
        profileRecord[SMProfile.kLastName] = viewModel.lastName
        profileRecord[SMProfile.kCompanyName] = viewModel.companyName
        profileRecord[SMProfile.kBio] = viewModel.bio
        profileRecord[SMProfile.kAvatar] = viewModel.avatar.convertToCKAsset()
        
        // get our UserRecordID from the Container
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            // get UserRecord from the Public Database
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                // create reference on UserRecord to the SMProfile we create
                userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .deleteSelf)
                
                // create a CKOperation to save our User and Profile Records
                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord, profileRecord])
                
                operation.modifyRecordsResultBlock = { result in
                    switch result {
                    case .success:
                        print("Successfully created and uploaded profile to CloudKit")
                    case .failure:
                        print("Error creating profile: ", error!.localizedDescription)
                    }
                }
                
                CKContainer.default().publicCloudDatabase.add(operation)
            }
        }
    }
    
    func getProfile() {
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print("Failed to get user's record")
                    print(error!.localizedDescription)
                    return
                }

                let profileReference = userRecord["userProfile"] as! CKRecord.Reference
                let profileRecordID = profileReference.recordID
                
                CKContainer.default().publicCloudDatabase.fetch(withRecordID: profileRecordID) { profileRecord, error in
                    guard let profileRecord = profileRecord, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    // Go to main thread to update the UI
                    DispatchQueue.main.async {
                        let profile = SMProfile(record: profileRecord)
                        viewModel.firstName = profile.firstName
                        viewModel.lastName = profile.lastName
                        viewModel.companyName = profile.companyName
                        viewModel.bio = profile.bio
                        viewModel.avatar = profile.createAvatarImage()
                    }
                }
            }
        }
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
