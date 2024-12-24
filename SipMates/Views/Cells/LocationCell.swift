//
//  LocationCell.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/27/24.
//

import SwiftUI

struct LocationCell: View {

    var location: SMLocation
    var profiles: [SMProfile]

    var body: some View {
        HStack {
            Image(uiImage: location.squareImage)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding(.vertical, 6)

            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                if profiles.isEmpty {
                    Text("Nobody's Checked In")
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                } else {
                    HStack {
                        ForEach(profiles.indices, id: \.self) { index in
                            if index <= 3 {
                                AvatarView(size: 35, image: profiles[index].avatarImage)
                            } else if index == 4 {
                                AdditionalProfilesView(number: min(profiles.count - 4, 99))
                            }
                        }
                    }
                }
            }
            .padding(.leading)
        }
    }
}

#Preview {
    LocationCell(location: SMLocation(record: MockData.location), profiles: [])
}

struct AdditionalProfilesView: View {
    
    var number: Int
    
    var body: some View {
        Text("+\(number)")
            .font(.system(size: 14, weight: .semibold))
            .frame(width: 35, height: 35)
            .foregroundStyle(.white)
            .background(.brandPrimary)
            .clipShape(Circle())
    }
}
