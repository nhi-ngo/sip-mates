//
//  AppTabViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/28/24.
//

import SwiftUI

extension AppTabView {
    
    final class AppTabViewModel: ObservableObject {
        
        @Published var isShowingOnboardView = false
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet { isShowingOnboardView = true }
        }
        
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        func checkIfHasSeenOnboard() {
            if !hasSeenOnboardView { hasSeenOnboardView = true }
        }
    }
}


