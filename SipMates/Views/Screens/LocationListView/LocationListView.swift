//
//  LocationListView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    @State private var viewModel = LocationListViewModel()
    
    var body: some View {
        NavigationStack {
            List(locationManager.locations) { location in
                NavigationLink(value: location) {
                    LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
                }
            }
            .listStyle(.plain)
            .navigationTitle("Grub Spots")
            .navigationDestination(for: SMLocation.self, destination: { location in
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            })
            .task { await viewModel.getCheckedInProfilesDictionary() }
            .refreshable { await viewModel.getCheckedInProfilesDictionary() }
            .alert(item: $viewModel.alertItem, content: { $0.alert })
        }
    }
}

#Preview {
    LocationListView()
        .environmentObject(LocationManager())
}
