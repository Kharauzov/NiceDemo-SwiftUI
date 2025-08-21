//
//  WCService.swift
//  NiceDemo-SwiftUI
//
//  Created by Serhii Kharauzov on 18.08.2025.
//

import Foundation
import WatchConnectivity

/// WatchConnectivity Service
@Observable
class WCService: NSObject {
    static let shared = WCService()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    var isAuthenticated: Bool = false {
        didSet {
            if oldValue != isAuthenticated {
                print("Auth changed: \(isAuthenticated)")
                isAuthenticatedChanged?(isAuthenticated)
            }
        }
    }
    var favBreedsPayload: FavoriteBreedsPayload? {
        didSet {
            if oldValue != favBreedsPayload, let favBreedsPayload {
                print("favoriteBreeds changed: \(favBreedsPayload)")
                favBreedsPayloadChanged?(favBreedsPayload)
            }
        }
    }
    var isAuthenticatedChanged: ((Bool) -> Void)?
    var favBreedsPayloadChanged: ((FavoriteBreedsPayload) -> Void)?
    
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
            debugPrint("updateApplicationContext error:", error)
        }
    }
    
    func sendFavoriteBreeds(_ payload: FavoriteBreedsPayload) {
        guard let session else { return }
        var appContext: [String: Any] = [:]
        do {
            let data = try JSONEncoder().encode(payload)
            appContext[Keys.favoriteBreeds.rawValue] = data
            try session.updateApplicationContext(appContext)
        } catch {
            debugPrint("updateApplicationContext error:", error)
        }
    }
    
    // MARK: - Apply inbound context
    
    private func apply(context: [String: Any]) {
        if let flag = context[Keys.isAuthenticated.rawValue] as? Bool {
            DispatchQueue.main.async { [weak self] in
                self?.isAuthenticated = flag
            }
        } else if let data = context[Keys.favoriteBreeds.rawValue] as? Data,
                  let incoming = try? JSONDecoder().decode(FavoriteBreedsPayload.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                self?.favBreedsPayload = incoming
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

extension WCService {
    enum Keys: String {
        case isAuthenticated
        case favoriteBreeds
    }
}
