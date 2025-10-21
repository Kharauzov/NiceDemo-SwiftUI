//
//  LoadingRowView.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 06.08.2025.
//

import SwiftUI

struct LoadingRowView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Rectangle()
                            .foregroundStyle(Color.AppColors.primary.opacity(0.8))
                            .frame(height: GridLayout.doubleRegularSpace)
                            .frame(width: geometry.size.width * 0.5)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Rectangle()
                            .foregroundStyle(Color.AppColors.primary.opacity(0.75))
                            .frame(height: GridLayout.doubleRegularSpace)
                            .frame(width: geometry.size.width * 0.4)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Spacer()
                    VStack {
                        RoundedRectangle(cornerRadius: geometry.size.width / 2)
                            .foregroundStyle(Color.AppColors.primary.opacity(0.75))
                            .frame(width: 40, height: 40)
                    }
                }
                SeparatorView()
            }
            .padding(.horizontal, GridLayout.doubleRegularSpace)
            .padding(.vertical, GridLayout.regularSpace)
        }
#if os(iOS)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
#endif
    }
}

#Preview {
    List {
        ForEach((1...10), id: \.self) { _ in
            LoadingRowView()
                .frame(height: 60)
        }
    }
}
