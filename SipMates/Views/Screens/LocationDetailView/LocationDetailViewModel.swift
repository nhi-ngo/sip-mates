//
//  LocationDetailViewModel.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/19/24.
//

import SwiftUI
import MapKit

final class LocationDetailViewModel: ObservableObject {
    
    @Published var isShowingProfileModal = false
    
    var location: SMLocation
        
    init(location: SMLocation) {
        self.location = location
    }
    
    func getDirectionsToLocation() {
        let placemark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        mapItem.phoneNumber = location.phoneNumber
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else { return }
        UIApplication.shared.open(url)
    }
}
