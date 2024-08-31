//
//  CloudKitManager.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/29/24.
//

import CloudKit

enum SipMatesError: LocalizedError {
    case unableToGetLocations
    
    var errorDescription: String? {
        switch self {
        case .unableToGetLocations:
            "Unable to retrieve locations."
        }
    }
        
    var failureReason: String {
        switch self {
        case .unableToGetLocations:
            "Unable to retrieve locations at this time. \nPlease try again later."
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
