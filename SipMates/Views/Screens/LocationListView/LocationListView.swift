//
//  LocationListView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI

struct LocationListView: View {
    
    @State private var locations: [SMLocation] = [SMLocation(record: MockData.location)]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(locations) { location in
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
}
