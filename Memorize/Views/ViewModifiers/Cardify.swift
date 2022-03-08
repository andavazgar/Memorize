//
//  Cardify.swift
//  Memorize
//
//  Created by Andres Vazquez on 2022-03-06.
//

import SwiftUI

struct Cardify: Animatable, ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    private var rotation = 0.0  // in degrees
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if rotation < 90 {
                cardShape.fill()
                    .foregroundColor(colorScheme == .light ? .white : .white.opacity(0.9))
                cardShape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                cardShape.fill()
                cardShape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            }
            
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

// MARK: - View Extension
extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}

// MARK: - Preview
struct Cardify_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text("😜")
                .cardify(isFaceUp: true)
            Text("😜")
                .cardify(isFaceUp: false)
        }
        .previewLayout(.fixed(width: 200, height: 300))
    }
}
