//
//  XDismissButton.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/11/24.
//

import SwiftUI

struct XDismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(.brandPrimary)
            Image(systemName: "xmark")
                .foregroundStyle(.white)
                .imageScale(.small)
                .frame(width: 44, height: 44)
        }
    }
}

#Preview {
    XDismissButton()
}
