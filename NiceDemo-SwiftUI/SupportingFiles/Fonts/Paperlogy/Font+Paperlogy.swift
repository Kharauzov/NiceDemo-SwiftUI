//
//  Font+Paperlogy.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 04.08.2025.
//

import SwiftUI

extension Font {
    static func paperlogy(_ weight: FontWeight = .regular, fontSize: CGFloat = 14) -> Font {
        switch weight {
        case .regular:
            return .custom("Paperlogy-4Regular", size: fontSize)
        case .medium:
            return .custom("Paperlogy-6Medium", size: fontSize)
        case .semibold:
            return .custom("Paperlogy-6SemiBold", size: fontSize)
        case .bold:
            return .custom("Paperlogy-7Bold", size: fontSize)
        }
    }
    
    enum FontWeight {
        case regular
        case medium
        case semibold
        case bold
    }
}

struct Paperlogy_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        var body: some View {
            VStack(spacing: 20) {
                Text("This is regular text")
                    .font(.paperlogy(.regular, fontSize: 18))
                Text("This is medium text")
                    .font(.paperlogy(.medium, fontSize: 18))
                Text("This is semibold text")
                    .font(.paperlogy(.semibold, fontSize: 18))
                Text("This is bold text")
                    .font(.paperlogy(.bold, fontSize: 18))
            }
        }
    }
}
