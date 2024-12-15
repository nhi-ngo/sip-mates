//
//  UIImage+Ext.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/14/24.
//

import CloudKit
import UIKit

extension UIImage {
    
    func convertToCKAsset() -> CKAsset? {
        // get our apps base document directory url
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document directory url came back nil")
            return nil
        }
        
        // append unique identifier for profile image
        let fileUrl = urlPath.appendingPathComponent("selectedAvatar")
        
        // write the image data to the location the address points to
        guard let imageData = jpegData(compressionQuality: 0.25) else { return nil }
        
        // create our CKAsset with that fileURL
        do {
            try imageData.write(to: fileUrl)
            return CKAsset(fileURL: fileUrl)
        } catch {
            return nil
        }
    }
}
