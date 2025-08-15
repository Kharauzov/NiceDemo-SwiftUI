//
//  SegmentedUnderlineTabs.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 10.08.2025.
//

import SwiftUI

struct SegmentedUnderlineTabs<T: Hashable & RawRepresentable<String>>: View {
    let tabs: [T]
    @Binding var selected: T
    let underline: Namespace.ID

    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 0) {
                Spacer()
                ForEach(tabs, id: \.self) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: AnimationDuration.macroFast.timeInterval)) {
                            selected = tab
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Text(tab.rawValue.capitalized)
                                .font(.paperlogy(.semibold, fontSize: 18))
                                .foregroundStyle(selected == tab ? Color.AppColors.primary : .gray)
                            ZStack {
                                if selected == tab {
                                    Capsule()
                                        .matchedGeometryEffect(id: "underline", in: underline)
                                        .frame(height: 2)
                                        .foregroundStyle(Color.AppColors.primary)
                                } else {
                                    Color.clear.frame(height: 2)
                                }
                                Rectangle()
                                    .fill(Color.AppColors.black.opacity(0.2))
                                    .frame(height: 1)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
        }
    }
}
