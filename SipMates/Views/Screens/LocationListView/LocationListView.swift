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
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: LocationDetailView(viewModel: LocationDetailViewModel(location: location)), label: {
                       LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
                   })
                }
            }
            .listStyle(.plain)
            .navigationTitle("Grub Spots")
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
