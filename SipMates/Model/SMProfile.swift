//
//  SMProfile.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/29/24.
//

import CloudKit
import UIKit

struct SMProfile {
    static let kFirstName    = "firstName"
    static let kLastName     = "lastName"
    static let kAvatar       = "avatar"
    static let kCompanyName  = "companyName"
    static let kBio           = "bio"
    static let kIsCheckedIn  = "isCheckedIn"
    
    let ckRecordId: CKRecord.ID
    let firstName: String
    let lastName: String
    let avatar: CKAsset!
    let companyName: String
    let bio: String
    let isCheckedIn: CKRecord.Reference? = nil

    init(record: CKRecord) {
        ckRecordId   = record.recordID
        firstName    = record[SMProfile.kFirstName] as? String ?? "N/A"
        lastName    = record[SMProfile.kLastName] as? String ?? "N/A"
        avatar       = record[SMProfile.kAvatar] as? CKAsset
        companyName  = record[SMProfile.kCompanyName] as? String ?? "N/A"
        bio          = record[SMProfile.kBio] as? String ?? "N/A"
    }
    
    func createAvatarImage() -> UIImage {
        guard let avatar = avatar else { return PlaceholderImage.avatar }
        return avatar.convertToUIImage(in: .square)
    }
}
