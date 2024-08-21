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
                ForEach(0..<10) { _ in
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
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
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

struct AvatarView: View {
    
    var size: CGFloat
    
    var body: some View {
        Image("default-avatar")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}
