//
//  LogoView.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/11/24.
//

import SwiftUI

struct LogoView: View {
    
    var logoWidth: CGFloat
    
    var body: some View {
        Image("sm-map-logo")
            .resizable()
            .scaledToFit()
            .frame(width: logoWidth)
    }
}

#Preview {
    LogoView(logoWidth: 100)
}
