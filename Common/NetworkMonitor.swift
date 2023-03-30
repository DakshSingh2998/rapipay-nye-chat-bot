//
//  NetworkMonitor.swift
//  Chat
//
//  Created by Daksh on 30/03/23.
//

import Foundation
import SwiftUI
import Network

enum NetworkStatus: String {
    case connected
    case disconnected
}
class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
        private let queue = DispatchQueue(label: "Monitor")

        @Published var status: NetworkStatus = .connected

        init() {
            self.monitor.start(queue: self.queue)
            monitor.pathUpdateHandler = { [weak self] path in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    if path.status == .satisfied {
                        self.status = .connected

                    } else {
                        self.status = .disconnected
                    }
                })

            }
            
        }
}
