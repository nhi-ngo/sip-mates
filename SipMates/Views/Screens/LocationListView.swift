//
//  LocationListView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/20/24.
//

import SwiftUI

struct LocationListView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<10) { location in
                   NavigationLink(destination: LocationDetailView(), label: {
                       LocationCell()
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
