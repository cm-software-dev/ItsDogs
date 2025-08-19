//
//  FontExtension.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 11/08/2025.
//

import SwiftUI

enum FontFuturaType: String {
    case Bold="Futura-Bold"
    case Thin="Futura-Thin"
    case ExtraLight="Futura-ExtraLight"
    case SemiBold="Futura-SemiBold"
    case Medium="Futura-Medium"
    case Regular="Futura-Regular"
    case Black="Futura-Black"
    case Light="Futura-Light"
}

struct FontFutura: ViewModifier {
    var size:CGFloat
    var type:FontFuturaType
    func body(content: Content) -> some View {
        content.font(.custom(type.rawValue, size: size))
    }
}

extension View {
    func fontAppDefault(size:CGFloat = 16,_ type:FontFuturaType = .Regular) -> some View {
        modifier(FontFutura(size:size,type:type))
    }
    
    func fontAppDefaultBold(size:CGFloat = 16) -> some View {
        modifier(FontFutura(size:size,type:.Bold))
    }
    
}
