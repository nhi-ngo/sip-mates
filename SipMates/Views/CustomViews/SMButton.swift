//
//  Button.swift
//  SipMates
//
//  Created by Nhi Ngo on 8/27/24.
//

import SwiftUI

struct SMButton: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .bold()
            .frame(width: 280, height: 44)
            .background(.brandPrimary)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    SMButton(title: "Test button")
}
