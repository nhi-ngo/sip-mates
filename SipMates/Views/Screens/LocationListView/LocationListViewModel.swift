//
//  LocationListViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 12/16/24.
//

import SwiftUI
import CloudKit

extension LocationListView {
    
    @MainActor @Observable
    final class LocationListViewModel {
        var checkedInProfiles: [CKRecord.ID: [SMProfile]] = [:]
        var alertItem: AlertItem?
        
        func getCheckedInProfilesDictionary() async {
//            do {
//                checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesDictionary()
//            } catch {
//                alertItem = AlertContext.unableToGetAllCheckedInProfiles
//            }
        }
    }
}
