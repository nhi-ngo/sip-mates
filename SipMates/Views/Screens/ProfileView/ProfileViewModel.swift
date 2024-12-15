//
//  ProfileViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/12/24.
//

import Foundation
import CloudKit

enum ProfileContext { case create, update }

extension ProfileView {
    
    @MainActor @Observable
    final class ProfileViewModel {
        var firstName             = ""
        var lastName              = ""
        var companyName           = ""
        var bio                   = ""
        var avatar                = PlaceholderImage.avatar
        var isLoading             = false
        
        var isShowingAlert = false
        var profileError: ProfileError = .invalidProfile
        
        @ObservationIgnored
        var profileContext: ProfileContext = .create
        var buttonTitle: String { profileContext == .create ? "Create Profile" : "Update Profile" }
        
        private func isProfileValid() -> Bool {
            guard !firstName.isEmpty,
                  !lastName.isEmpty,
                  !companyName.isEmpty,
                  !bio.isEmpty,
                  avatar != PlaceholderImage.avatar,
                  bio.count <= 100 else { return false }
            
            return true
        }
        
        func determineButtonAction() {
            profileContext == .create ? createProfile() : updateProfile()
        }
        
        private func createProfile() {
            guard isProfileValid() else {
                isShowingAlert = true
                profileError = .invalidProfile
                return
            }
            
            // create CKRecord from profile view
            let profileRecord = createProfileRecord()
            guard let userRecord = CloudKitManager.shared.userRecord else {
                isShowingAlert = true
                profileError = .noUserRecord
                return
            }
            
            // create reference on UserRecord to the SMProfile we create
            userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
            
            showLoadingView()
            
            Task {
                do {
                    let records = try await CloudKitManager.shared.batchSave(records: [userRecord, profileRecord])
                    for record in records where record.recordType == RecordType.profile {
                        CloudKitManager.shared.profileRecordID = record.recordID
                    }
                    hideLoadingView()
                    isShowingAlert = true
                    profileError = .createProfileSuccess
                } catch {
                    hideLoadingView()
                    isShowingAlert = true
                    profileError = .createProfileFailure
                }
            }
        }
        
        func getProfile() {
            guard let userRecord = CloudKitManager.shared.userRecord else {
                isShowingAlert = true
                profileError = .noUserRecord
                return
            }
                        
            guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else {
                print("Unable to get profile reference")
                return
            }

            let _ = print("profileReference: ", profileReference)

            let profileRecordID = profileReference.recordID
            
            showLoadingView()
            
            Task {
                do {
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
//                    existingProfileRecord = record
                    
                    let profile = SMProfile(record: record)
                    firstName   = profile.firstName
                    lastName    = profile.lastName
                    companyName = profile.companyName
                    bio         = profile.bio
                    avatar      = profile.avatarImage
                    let _ = print("success profile: ", profile)

                    hideLoadingView()
                } catch {
                    isShowingAlert = true
                    profileError = .unableToRetrieveProfile
                    print("Failed fetching user record")
                }
            }
        }
        
        private func updateProfile() {
            
        }
        
        private func createProfileRecord() -> CKRecord {
            let profileRecord = CKRecord(recordType: RecordType.profile)
            profileRecord[SMProfile.kFirstName] = firstName
            profileRecord[SMProfile.kLastName] = lastName
            profileRecord[SMProfile.kCompanyName] = companyName
            profileRecord[SMProfile.kBio] = bio
            profileRecord[SMProfile.kAvatar] = avatar.convertToCKAsset()
            
            return profileRecord
        }
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
    }
}

enum ProfileError: LocalizedError {
    case invalidProfile
    case noUserRecord
    case createProfileSuccess
    case createProfileFailure
    case unableToRetrieveProfile
    
    var errorDescription: String? {
        switch self {
        case .invalidProfile:
            "Invalid Profile"
        case .noUserRecord:
            "No User Record"
        case .createProfileSuccess:
            "Profile created successfully!"
        case .createProfileFailure:
            "Failed to create profile"
        case .unableToRetrieveProfile:
            "Failed to retrieve profile"
        }
    }
    
    var failureReason: String {
        switch self {
        case .invalidProfile:
            "All fields are required as well as a profile photo. Your bio must be < 100 characters. \nPlease try again."
        case .noUserRecord:
            "You must log into iCloud on your phone in order to utilize SipMates' Profile."
        case .createProfileSuccess:
            "Your profile has successfully been created."
        case .createProfileFailure:
            "Unable to create profile at this time. \nPlease try again later."
        case .unableToRetrieveProfile:
            "Unable to retrieve profile at this time. \nPlease try again later."
        }
    }
}


