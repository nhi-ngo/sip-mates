//
//  MockData.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/29/24.
//

import CloudKit

struct MockData {
    
    static var location: CKRecord {
        let record = CKRecord(recordType: RecordType.location)
        
        record[SMLocation.kName] = "Nhi's Bar and Grill"
        record[SMLocation.kDescription] = "This is a test description."
        record[SMLocation.kAddress] = "123 Main Street"
        record[SMLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[SMLocation.kWebsiteURL] = "https://apple.com"
        record[SMLocation.kPhoneNumber] = "111-111-1111"
        
        return record
    }
}
