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

final class CloudKitManager {
    static let shared = CloudKitManager()
    
    private init() {}
    
    let container = CKContainer.default()
    var userRecord: CKRecord?
    var profileRecordID: CKRecord.ID?
    
    func getUserRecord() async throws {
        let recordID = try await container.userRecordID()
        let record = try await container.publicCloudDatabase.record(for: recordID)
        userRecord = record
        
        if let profileReference = record["userProfile"] as? CKRecord.Reference {
            profileRecordID = profileReference.recordID
        }
    }
    
    func getLocations() async throws -> [SMLocation] {
        let sortDescriptor = NSSortDescriptor(key: SMLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        let (matchResults, _ ) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        return records.map(SMLocation.init)
    }
    
    func batchSave(records: [CKRecord]) {
        // create a CKOperation to save our User and Profile Records
        let operation = CKModifyRecordsOperation(recordsToSave: records)
        
        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success:
                // TODO: show alert
                print("Successfully created and uploaded profile to CloudKit")
            case .failure:
                // TODO: show alert
                print("Error creating profile")
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func fetchRecord(with id: CKRecord.ID, completed: @escaping (Result<CKRecord, Error>) -> Void) {
        container.publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record, error == nil else {
                completed(.failure(error!))
                print("Unable to fetch user record")
                return
            }
            
            completed(.success(record))
        }
    }
}
