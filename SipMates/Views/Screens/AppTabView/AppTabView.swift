//
//  AppTabView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI

struct AppTabView: View {
    
    @StateObject private var viewModel = AppTabViewModel()
    
    var body: some View {
        TabView {
            LocationMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            LocationListView()
                .tabItem {
                    Label("Locations", systemImage: "building")
                }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
            .navigationTitle("Profile")
        }
        .task {
            try? await CloudKitManager.shared.getUserRecord()
        }
        .onAppear {
            viewModel.runStartupChecks()
        }
        .sheet(isPresented: $viewModel.isShowingOnboardingView, onDismiss: viewModel.checkIfLocationServicesIsEnabled) {
            OnboardingView(isShowingOnboardingView: $viewModel.isShowingOnboardingView)
        }
        .tabViewDefaultBackground()
    }
}

#Preview {
    AppTabView()
}

// iOS 15 changes the default appearance of Tab bars from opaque to transparent. To make them opaque:
extension View {
    func tabViewDefaultBackground() -> some View {
        self.onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}
