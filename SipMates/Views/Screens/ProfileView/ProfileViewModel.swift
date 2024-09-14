//
//  ProfileViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/12/24.
//

import Foundation

@Observable
class ProfileViewModel {
    var firstName             = ""
    var lastName              = ""
    var companyName           = ""
    var bio                   = ""
    var avatar                = PlaceholderImage.avatar
    var isLoading             = false
}
