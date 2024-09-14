//
//  ProfileViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/12/24.
//

import Foundation

enum FormError: LocalizedError {
    case invalidProfile
    
    var errorDescription: String? {
        switch self {
        case .invalidProfile:
            "Invalid Profile"
        }
    }
    
    var failureReason: String {
        switch self {
        case .invalidProfile:
            "All fields are required as well as a profile photo. Your bio must be < 100 characters. \nPlease try again."
        }
    }
}

@Observable
class ProfileViewModel {
    var firstName             = ""
    var lastName              = ""
    var companyName           = ""
    var bio                   = ""
    var avatar                = PlaceholderImage.avatar
    var isLoading             = false
}
