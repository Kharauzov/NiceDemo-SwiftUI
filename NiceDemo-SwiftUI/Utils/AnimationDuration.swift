//
//  AnimationDuration.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 14.08.2025.
//

import Foundation

enum AnimationDuration: TimeInterval {
    /// 0.1 sec
    case microFast = 0.1
    /// 0.2 sec
    case microRegular = 0.2
    /// 0.3 sec
    case microSlow = 0.3

    /// 0.4 sec
    case macroFast = 0.4
    /// 0.5 sec
    /// default animation duration
    case macroRegular = 0.5
    /// 0.6 sec
    case macroSlow = 0.6

    var timeInterval: TimeInterval {
        return rawValue
    }
}
