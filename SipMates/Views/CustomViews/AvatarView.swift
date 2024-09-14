//
//  AvatarView.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/27/24.
//

import SwiftUI

struct AvatarView: View {
    
    var size: CGFloat
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

#Preview {
    AvatarView(size: 90, image: PlaceholderImage.avatar)
}
