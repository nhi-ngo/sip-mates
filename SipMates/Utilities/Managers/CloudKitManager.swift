//
//  CloudKitManager.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/29/24.
//

import CloudKit

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
    
    
    // Retrieves checked in profiles for specific restaurant
    /// - Parameter locationID: location  ID for the restaurant
    /// - Returns: a list of users checked into the restaurant
    func getCheckedInProfiles(for locationID: CKRecord.ID) async throws -> [SMProfile] {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        return records.map(SMProfile.init)
    }
    
    func getCheckedInProfilesDictionary() async throws -> [CKRecord.ID: [SMProfile]] {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        var checkedInProfiles: [CKRecord.ID: [SMProfile]] = [:]
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        
        for record in records {
            let profile = SMProfile(record: record)
            guard let locationRef = record[SMProfile.kIsCheckedIn] as? CKRecord.Reference else { continue }
            checkedInProfiles[locationRef.recordID, default: []].append(profile)
        }
                
        return checkedInProfiles
    }
    
    func getCheckedInProfilesCount() async throws -> [CKRecord.ID: Int] {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        var checkedInProfiles: [CKRecord.ID: Int] = [:]
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query, desiredKeys: [SMProfile.kIsCheckedIn])
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        for record in records {
            guard let locationRef = record[SMProfile.kIsCheckedIn] as? CKRecord.Reference else { continue }
            
            if let count = checkedInProfiles[locationRef.recordID] {
                checkedInProfiles[locationRef.recordID] = count + 1
            } else {
                checkedInProfiles[locationRef.recordID] = 1
            }
        }
        
        return checkedInProfiles
    }
    
    func batchSave(records: [CKRecord]) async throws -> [CKRecord] {
        let (savedResult, _) = try await container.publicCloudDatabase.modifyRecords(saving: records, deleting: [])
        return savedResult.compactMap { _, result in try? result.get() }
    }
    
    func save(record: CKRecord) async throws -> CKRecord {
        return try await container.publicCloudDatabase.save(record)
    }
    
    func fetchRecord(with id: CKRecord.ID) async throws -> CKRecord {
        return try await container.publicCloudDatabase.record(for: id)
    }
}
