//
//  MapBalloon.swift
//  SipMates
//
//  Created by Nhi Ngo on 9/22/24.
//

import SwiftUI

struct MapBalloon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY)) // starting point
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY),
                          control: CGPoint(x: rect.minX, y: rect.minY)) // control point at the upper left corner of the screen
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                          control: CGPoint(x: rect.maxX, y: rect.minY))
        
        return path
    }
}

#Preview {
    MapBalloon()
        .frame(width: 300, height: 240)
        .foregroundStyle(.brandPrimary)
}
