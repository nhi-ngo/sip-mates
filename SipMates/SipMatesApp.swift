//
//  SipMatesApp.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/19/24.
//

import SwiftUI

@main
struct SipMatesApp: App {
    
    let locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            AppTabView().environmentObject(locationManager)
        }
    }
}
