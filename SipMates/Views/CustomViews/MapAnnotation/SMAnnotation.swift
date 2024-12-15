//
//  SMAnnotation.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/22/24.
//

import SwiftUI

struct SMAnnotation: View {
    
    var location: SMLocation
    var number: Int
    
    var body: some View {
        VStack {
            ZStack {
                MapBalloon()
                    .frame(width: 100, height: 70)
                    .foregroundStyle(.brandPrimary)
                
                Image(uiImage: location.squareImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .offset(y: -12)
                
                if number > 0 {
                    Text("\(min(number, 99))")
                        .font(.system(size: 11, weight: .bold))
                        .frame(width: 26, height: 18)
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .offset(x: 20, y: -28)
                }
            }
            
            Text(location.name)
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    SMAnnotation(location: SMLocation(record: MockData.location), number: 44)
}
