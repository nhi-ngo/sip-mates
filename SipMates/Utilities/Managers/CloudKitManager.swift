//
//  CloudKitManager.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/29/24.
//

import CloudKit

enum SipMatesError: LocalizedError {
    case unableToGetLocations
    case locationRestricted
    case locationDenied
    case locationDisabled
    
    var errorDescription: String? {
        switch self {
        case .unableToGetLocations:
            "Locations Error"
        case .locationRestricted:
            "Locations Restricted"
        case .locationDenied:
            "Locations Denied"
        case .locationDisabled:
            "Location Service Disabled"
        }
    }
    
    var failureReason: String {
        switch self {
        case .unableToGetLocations:
            "Unable to retrieve locations at this time. \nPlease try again later."
        case .locationRestricted:
            "Location access is restricted."
        case .locationDenied:
            "SipMates does not have permission to access your location. To change that go to your phone's Settings > SipMates > Location"
        case .locationDisabled:
            "Your phone's location services are disabled. To change that go to your phone's Settings > Privacy > Location Services"
        }
    }
}

struct CloudKitManager {
    static let shared = CloudKitManager()
    
    let container = CKContainer.default()
    
    func getLocations() async throws -> [SMLocation] {
        let sortDescriptor = NSSortDescriptor(key: SMLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        let (matchResults, _ ) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        return records.map(SMLocation.init)
    }
}
