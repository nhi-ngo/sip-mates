//
//  LocationListView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI

struct LocationListView: View {
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        NavigationStack {
            List {
                let _ = print(locationManager.locations)

                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: LocationDetailView(location: location), label: {
                       LocationCell(location: location)
                   })
                }
            }
            .listStyle(.plain)
            .navigationTitle("Grub Spots")
        }
    }
}

#Preview {
    LocationListView()
        .environmentObject(LocationManager())
}
