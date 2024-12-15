//
//  SMLocation.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/29/24.
//

import CloudKit
import UIKit

struct SMLocation: Identifiable {
    static let kName = "name"
    static let kDescription = "description"
    static let kSquareAsset = "squareAsset"
    static let kBannerAsset = "bannerAsset"
    static let kAddress = "address"
    static let kLocation = "location"
    static let kWebsiteURL = "websiteURL"
    static let kPhoneNumber = "phoneNumber"
    
    let id: CKRecord.ID
    let name: String
    let description: String
    let squareAsset: CKAsset!
    let bannerAsset: CKAsset!
    let address: String
    let location: CLLocation
    let websiteURL: String
    let phoneNumber: String
    
    init(record: CKRecord) {
        id           = record.recordID
        name         = record[SMLocation.kName] as? String ?? "N/A"
        description = record[SMLocation.kDescription] as? String ?? "N/A"
        squareAsset = record[SMLocation.kSquareAsset] as? CKAsset
        bannerAsset = record[SMLocation.kBannerAsset] as? CKAsset
        address     = record[SMLocation.kAddress] as? String ?? "N/A"
        location    = record[SMLocation.kLocation] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
        websiteURL  = record[SMLocation.kWebsiteURL] as? String ?? "N/A"
        phoneNumber = record[SMLocation.kPhoneNumber] as? String ?? "N/A"
    }
    
    var squareImage: UIImage {
        guard let squareAsset else { return PlaceholderImage.square }
        return squareAsset.convertToUIImage(in: .square)
    }
    
    var bannerImage: UIImage {
        guard let bannerAsset else { return PlaceholderImage.banner }
        return bannerAsset.convertToUIImage(in: .banner)
    }
}
