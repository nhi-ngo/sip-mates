//
//  AvatarView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/27/24.
//

import SwiftUI

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

#Preview {
    AvatarView(size: 90)
}
