//
//  Extenstions.swift
//  SwipeHiddenHeader
//
//  Created by Koji Kawakami on 2022/07/21.
//

import SwiftUI

extension View{
    @ViewBuilder
    func offsetY(completion: @escaping(CGFloat,CGFloat)->())-> some View{
        self
            .modifier(OffsetHelper(onChange: completion))
    }
    
    func safeArea()-> UIEdgeInsets{
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return .zero}
        guard let safeArea = scene.windows.first?.safeAreaInsets else{return .zero}
        return safeArea
    }
}

struct OffsetHelper: ViewModifier{
    var onChange: (CGFloat,CGFloat)->()
    @State var currentOffset: CGFloat = 0
    @State var previousOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay{
                GeometryReader{proxy in
                    let minY = proxy.frame(in:.named("SCROLL")).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self){ value in
                            previousOffset = currentOffset
                            currentOffset = value
                            onChange(previousOffset,currentOffset)
                        }
                    
                }
            }
    }
}

struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HeaderBoundsKey: PreferenceKey{
    static var defaultValue: Anchor<CGRect>?
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}
