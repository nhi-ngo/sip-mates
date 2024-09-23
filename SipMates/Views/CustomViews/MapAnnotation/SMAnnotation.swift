//
//  SMAnnotation.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/22/24.
//

import SwiftUI

struct SMAnnotation: View {
    
    var location: SMLocation
    
    var body: some View {
        VStack {
            ZStack {
                MapBalloon()
                    .frame(width: 100, height: 70)
                    .foregroundStyle(.brandPrimary)
                
                Image(uiImage: location.createSquareImage())
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .offset(y: -12)
                
                Text("99")
                    .font(.system(size: 11, weight: .bold))
                    .frame(width: 26, height: 18)
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .offset(x: 20, y: -28)
            }
            
            Text(location.name)
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    SMAnnotation(location: SMLocation(record: MockData.location))
}
