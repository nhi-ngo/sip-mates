//
//  LocationCell.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/27/24.
//

import SwiftUI

struct LocationCell: View {
    
    var body: some View {
        HStack {
            Image("default-square-asset")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding(.vertical, 6)
            
            VStack(alignment: .leading) {
                Text("Restaurant nameeeeeeeeeeeeee")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                
                HStack {
                    AvatarView(size: 30)
                    AvatarView(size: 30)
                    AvatarView(size: 30)
                    AvatarView(size: 30)
                    AvatarView(size: 30)
                }
            }
            .padding(.leading, 5)
        }
    }
}

#Preview {
    LocationCell()
}
