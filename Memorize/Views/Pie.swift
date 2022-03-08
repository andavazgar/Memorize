//
//  Pie.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-02-24.
//

import SwiftUI

struct Pie: Shape {
    let origin: PieOriginLocation
    var startAngle: Angle
    var endAngle: Angle
    let clockwise: Bool
    
    var animatableData: Double {
        get { endAngle.degrees }
        set { endAngle = .degrees(newValue) }
    }
    
    init(origin: PieOriginLocation = .top, startAngle: Angle, endAngle: Angle, clockwise: Bool = true) {
        self.origin = origin
        self.startAngle = startAngle + origin.rotationAdjustment
        self.endAngle = endAngle + origin.rotationAdjustment
        self.clockwise = !clockwise
    }
    
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startPoint = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: startPoint)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        path.addLine(to: center)
        
        return path
    }
    
    enum PieOriginLocation {
        case top, right
        
        var rotationAdjustment: Angle {
            switch self {
            case .right:
                return .zero
            case .top:
                return .degrees(-90)
            }
        }
    }
    
}

struct Pie_Previews: PreviewProvider {
    static var previews: some View {
        Pie(startAngle: .degrees(0), endAngle: .degrees(270))
            .padding(5)
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
