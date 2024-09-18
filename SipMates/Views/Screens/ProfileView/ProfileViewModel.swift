//
//  ProfileViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/12/24.
//

import Foundation
import CloudKit

enum FormError: LocalizedError {
    case invalidProfile
    
    var errorDescription: String? {
        switch self {
        case .invalidProfile:
            "Invalid Profile"
        }
    }
    
    var failureReason: String {
        switch self {
        case .invalidProfile:
            "All fields are required as well as a profile photo. Your bio must be < 100 characters. \nPlease try again."
        }
    }
}

@MainActor final class ProfileViewModel: ObservableObject {
    @Published var firstName             = ""
    @Published var lastName              = ""
    @Published var companyName           = ""
    @Published var bio                   = ""
    @Published var avatar                = PlaceholderImage.avatar
    @Published var isLoading             = false
    
    @Published var isShowingAlert = false
    @Published var formError: FormError = .invalidProfile
    
    func isProfileValid() -> Bool {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              !bio.isEmpty,
              avatar != PlaceholderImage.avatar,
              bio.count <= 100 else { return false }
        
        return true
    }
    
    func createProfile() {
        guard isProfileValid() else {
            isShowingAlert = true
            formError = .invalidProfile
            return
        }
        
        // create CKRecord from profile view
        let profileRecord = createProfileRecord()
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            // TODO: show alert
            return
        }
        
        // create reference on UserRecord to the SMProfile we create
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .deleteSelf)
        
        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord])
    }
    
    func getProfile() async throws {
        guard let userRecord = CloudKitManager.shared.userRecord else {
            //TODO: show alert
            print("Unable to get user record")
            return
        }
        
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else {
            //TODO: show alert
            print("Unable to get profile reference")
            return
        }
        

        let profileRecordID = profileReference.recordID
        let _ = print(userRecord)
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let record):
                    let profile  = SMProfile(record: record)
                    firstName   = profile.firstName
                    lastName    = profile.lastName
                    companyName = profile.companyName
                    bio          = profile.bio
                    avatar      = profile.createAvatarImage()
                    
                case .failure(_):
                    //TODO: show alert
                    print("Failed fetching user record")
                    break
                }
            }
        }
    }
    
    private func createProfileRecord() -> CKRecord {
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[SMProfile.kFirstName] = firstName
        profileRecord[SMProfile.kLastName] = lastName
        profileRecord[SMProfile.kCompanyName] = companyName
        profileRecord[SMProfile.kBio] = bio
        profileRecord[SMProfile.kAvatar] = avatar.convertToCKAsset()
        
        let _ = print("profileRecord: ", profileRecord)
        return profileRecord
    }
}
