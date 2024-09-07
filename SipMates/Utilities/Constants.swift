//
//  Constants.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/31/24.
//

import UIKit
import SwiftUI

enum RecordType {
    static let location = "SMLocation"
    static let profile = "SMProfile"
}

enum PlaceholderImage {
    static let avatar = UIImage(named: "default-avatar")!
    static let square = UIImage(named: "default-square-asset")!
    static let banner = UIImage(named: "default-banner-asset")!
}

enum ImageDimension {
    case square, banner
    
    static func getPlaceholder(for dimension: ImageDimension) -> UIImage {
        switch dimension {
        case .square:
            return PlaceholderImage.square
        case .banner:
            return PlaceholderImage.banner
        }
    }
}
