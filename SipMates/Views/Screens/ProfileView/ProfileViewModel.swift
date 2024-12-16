//
//  ProfileViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/12/24.
//

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
        var isShowingPhotoPicker = false
        var isLoading            = false
        var isCheckedIn          = false
        var alertItem: AlertItem?
        
        @ObservationIgnored
        private var existingProfileRecord: CKRecord? {
            didSet { profileContext = .update }
        }
        
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
        
        func getCheckedInStatus() {
            guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
            
            Task {
                do {
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                    if let _ = record[SMProfile.kIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = true
                    } else {
                        isCheckedIn = false
                    }
                } catch {
                    print("Unable to get checked in status")
                }
            }
        }
        
        func checkOut() {
            guard let profileID = CloudKitManager.shared.profileRecordID else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            showLoadingView()
            
            Task {
                do {
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileID)
                    record[SMProfile.kIsCheckedIn] = nil
                    
                    let _ = try await CloudKitManager.shared.save(record: record)
                    isCheckedIn = false
                    hideLoadingView()
                } catch {
                    hideLoadingView()
                    alertItem = AlertContext.unableToCheckInOrOut
                }
            }
        }
        
        private func createProfile() {
            guard isProfileValid() else {
                alertItem = AlertContext.invalidProfile
                return
            }
            
            // create CKRecord from profile view
            let profileRecord = createProfileRecord()
            guard let userRecord = CloudKitManager.shared.userRecord else {
                alertItem = AlertContext.noUserRecord
                return
            }
            
            // create reference on Users Record Types in CloudKit
            userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
            
            showLoadingView()
            
            Task {
                do {
                    let records = try await CloudKitManager.shared.batchSave(records: [userRecord, profileRecord])
                    for record in records where record.recordType == RecordType.profile {
                        existingProfileRecord = record
                        CloudKitManager.shared.profileRecordID = record.recordID
                    }
                    hideLoadingView()
                    alertItem = AlertContext.createProfileSuccess
                } catch {
                    hideLoadingView()
                    alertItem = AlertContext.createProfileFailure
                }
            }
        }
        
        func getProfile() {
            guard let userRecord = CloudKitManager.shared.userRecord else {
                alertItem = AlertContext.noUserRecord
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
                    existingProfileRecord = record
                    
                    let profile = SMProfile(record: record)
                    firstName   = profile.firstName
                    lastName    = profile.lastName
                    companyName = profile.companyName
                    bio         = profile.bio
                    avatar      = profile.avatarImage
                    let _ = print("success profile: ", profile)

                    hideLoadingView()
                } catch {
                    alertItem = AlertContext.unableToGetProfile
                    print("Failed fetching user record")
                }
            }
        }
        
        private func updateProfile() {
            guard isProfileValid() else {
                alertItem = AlertContext.invalidProfile
                return
            }
            
            guard let existingProfileRecord else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            existingProfileRecord[SMProfile.kFirstName] = firstName
            existingProfileRecord[SMProfile.kLastName] = lastName
            existingProfileRecord[SMProfile.kCompanyName] = companyName
            existingProfileRecord[SMProfile.kBio] = bio
            existingProfileRecord[SMProfile.kAvatar] = avatar.convertToCKAsset()
            
            showLoadingView()
            
            Task {
                do {
                    let _ = try await CloudKitManager.shared.save(record: existingProfileRecord)
                    hideLoadingView()
                    alertItem = AlertContext.updateProfileSuccess
                } catch {
                    hideLoadingView()
                    alertItem = AlertContext.updateProfileFailure
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
            
            return profileRecord
        }
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
    }
}


