//
//  InlineNavigationTitle.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 21.10.2025.
//

import SwiftUI

struct InlineNavigationTitle: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
    }
}

extension View {
    func inlineNavigationTitle(_ title: String) -> some View {
        self.modifier(InlineNavigationTitle(title: title))
    }
    
    func inlineNavigationTitle(_ title: NavigationTitle) -> some View {
        inlineNavigationTitle(title.rawValue)
    }
}
