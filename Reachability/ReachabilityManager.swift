//
//  ReachabilityManager.swift
//  Reachability
//
//  Created by Rapido on 06/10/22.
//

import Foundation
import Network

protocol NWPathMonitorInterface {
     var pathUpdateHandler: ((_ newPath: NWPath) -> Void)? {get set}
     func start(queue: DispatchQueue)
     func cancel()
     var currentPath: NWPath { get }
}

extension NWPathMonitor: NWPathMonitorInterface {}

final class ReachabilityManager {
    
    private(set) var isNetworkAvailable: Bool = false
    private(set) var connectionType: NWInterface.InterfaceType?
    private(set) var isMonitoring: Bool = false
    
    private let queue: DispatchQueue
    private var monitor: NWPathMonitorInterface?
    
    public var onUpdateNetworkStatus: ((Bool) -> Void)?
    static let shared = ReachabilityManager(monitor: NWPathMonitor(),
                                            queue: DispatchQueue(label: "com.rapido.networkMonitoring"))

    deinit {
        stopMonitoring()
    }
    
    init(monitor: NWPathMonitorInterface,
         queue: DispatchQueue) {
        self.monitor = monitor
        self.queue = queue
    }
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
    }
    
    public func startMonitoring() {
        guard !isMonitoring else {
            return
        }
        if monitor == nil {
            monitor = NWPathMonitor()
        }
        self.monitor?.start(queue: queue)
        self.monitor?
            .pathUpdateHandler = { [weak self] status in
                guard let self = self,
                      let monitor = self.monitor else { return }
            
                self.updateStatus(status: monitor.currentPath.status)
                self.updateConnectionType(interface: monitor.currentPath
                    .availableInterfaces
                    .map(\.type))
        }
        isMonitoring = true
    }
    
    
    func updateStatus(status: NWPath.Status) {
        isNetworkAvailable = status == .satisfied ? true : false
        onUpdateNetworkStatus?(isNetworkAvailable)
    }
    
    func updateConnectionType(interface: [NWInterface.InterfaceType]) {
        connectionType = interface.first
    }
    
    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
        isMonitoring = false
    }
}
