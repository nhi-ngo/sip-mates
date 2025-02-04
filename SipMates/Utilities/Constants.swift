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
    static let avatar = UIImage(resource: .defaultAvatar)
    static let square = UIImage(resource: .defaultSquareAsset)
    static let banner = UIImage(resource: .defaultBannerAsset)
}

enum ImageDimension {
    case square, banner
    
    var placeholder: UIImage {
        switch self {
        case .square:
            return PlaceholderImage.square
        case .banner:
            return PlaceholderImage.banner
        }
    }
}
