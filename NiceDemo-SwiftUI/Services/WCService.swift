//
//  WCService.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 18.08.2025.
//

import Foundation
import WatchConnectivity
import Combine

@Observable
final class WCService: NSObject {
    enum Keys: String {
        case isAuthenticated
    }

    static let shared = WCService()
    var isAuthenticated: Bool = false {
        didSet {
            if oldValue != isAuthenticated {
                print("Auth changed: \(isAuthenticated)")
                isAuthenticatedChanged?(isAuthenticated)
            }
        }
    }
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    var isAuthenticatedChanged: ((Bool) -> Void)?
    
    private override init() {
        super.init()
        session?.delegate = self
        session?.activate()
    }
    
    // MARK: - Send
    
    func sendAuth(flag: Bool) {
        guard let session else { return }
        var appContext = session.applicationContext
        appContext[Keys.isAuthenticated.rawValue] = flag
        do {
            try session.updateApplicationContext(appContext)
        } catch {
            debugPrint("WC updateApplicationContext error:", error)
        }
    }
    
    // MARK: - Apply inbound context
    
    private func apply(context: [String: Any]) {
        if let flag = context[Keys.isAuthenticated.rawValue] as? Bool {
            DispatchQueue.main.async { [weak self] in
                self?.isAuthenticated = flag
            }
        }
    }
}

// MARK: - WCSessionDelegate
extension WCService: WCSessionDelegate {
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        apply(context: session.receivedApplicationContext)
        apply(context: session.applicationContext)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        apply(context: applicationContext)
    }
}
