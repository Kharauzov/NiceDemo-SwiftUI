//
//  MockPhoneSignInConnectivityService.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 03.10.2025.
//

import Foundation
@testable import NiceDemo_SwiftUI

class MockPhoneSignInConnectivityService: PhoneSignInConnectivityInterface {
    var sendAuthCalled = 0
    var flag: Bool?
    
    func sendAuth(flag: Bool) {
        sendAuthCalled += 1
        self.flag = flag
    }
}
