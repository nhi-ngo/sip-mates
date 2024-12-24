//
//  LocationDetailViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/19/24.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus { case checkedIn, checkedOut }

@MainActor @Observable
final class LocationDetailViewModel {
    
    var checkedInProfiles: [SMProfile] = []
    var isShowingProfileModal = false
    var isCheckedIn = false
    var isLoading = false
    var alertItem: AlertItem?
    
    @ObservationIgnored var location: SMLocation
    @ObservationIgnored var selectedProfile: SMProfile?
    
    var checkInButtonColor: Color { isCheckedIn ? .red : .brandPrimary }
    var checkInButtonImage: String { isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark" }
        
    init(location: SMLocation) { self.location = location }
    
    func getDirectionsToLocation() {
        let placemark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        mapItem.phoneNumber = location.phoneNumber
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                if let reference = record[SMProfile.kIsCheckedIn] as? CKRecord.Reference {
                    isCheckedIn = reference.recordID == location.id
                } else {
                    isCheckedIn = false
                }
            } catch {
                alertItem = AlertContext.unableToGetCheckInStatus
            }
        }
    }
    
    func updateCheckInStatus(to checkInStatus: CheckInStatus) {
        // Retrieve profile
        // Create reference to location
        // Save updated profile to CK
        
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        showLoadingView()
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                switch checkInStatus {
                case .checkedIn:
                    record[SMProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                    record[SMProfile.kIsCheckedInNilCheck] = 1
                case .checkedOut:
                    record[SMProfile.kIsCheckedIn] = nil
                    record[SMProfile.kIsCheckedInNilCheck] = nil
                }
                
                let savedRecord = try await CloudKitManager.shared.save(record: record)
                let updatedProfile = SMProfile(record: savedRecord)
                
                switch checkInStatus {
                case .checkedIn:
                    checkedInProfiles.append(updatedProfile)
                case .checkedOut:
                    checkedInProfiles.removeAll(where: { $0.id == updatedProfile.id })
                }
                
                isCheckedIn.toggle()
                hideLoadingView()
            } catch {
                alertItem = AlertContext.unableToCheckInOrOut
            }
        }
    }
    
    func getCheckedInProfiles() {
        showLoadingView()
        
        Task {
            do {
                checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfiles(for: location.id)
                hideLoadingView()
            } catch {
                hideLoadingView()
                alertItem = AlertContext.unableToGetCheckedInProfiles
            }
        }
    }
    
    func show(_ profile: SMProfile) {
        selectedProfile = profile
        isShowingProfileModal = true
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
