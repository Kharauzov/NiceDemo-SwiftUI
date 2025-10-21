//
//  LoadingList.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 21.10.2025.
//

import SwiftUI

struct LoadingList: View {
    var count = 20 // default
    
    var body: some View {
        List {
            ForEach((1...count), id: \.self) { _ in
                LoadingRowView()
                    .frame(height: 60)
            }
        }
    }
}
