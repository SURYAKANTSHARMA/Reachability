//
//  ReachabilityManager.swift
//  Reachability
//
//  Created by Surya on 06/10/22.
//

import Foundation
import Network

protocol NWPathMonitorInterface {
     var pathUpdateHandler: ((_ newPath: NWPath) -> Void)? {get set}
     var currentPath: NWPath {get}

     func start(queue: DispatchQueue)
     func cancel()
}

extension NWPathMonitor: NWPathMonitorInterface {}

class ReachabilityManager {
    
    private(set) var isNetworkAvailable: Bool = false
    private(set) var connectionType: NWInterface.InterfaceType?
    
    private let queue: DispatchQueue
    private var monitor: NWPathMonitorInterface
    public var onUpdateNetworkStatus: ((Bool) -> Void)?
    
    static let shared = ReachabilityManager(monitor: NWPathMonitor(),
                                       queue: DispatchQueue.global(qos: .default))

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
        self.monitor.start(queue: queue)

        self.monitor
            .pathUpdateHandler = { [weak self] path in
                guard let self = self else { return }
                let availableTypes = path
                    .availableInterfaces
                    .map(\.type)
                
                self.updateStatus(status: path.status,
                                  interface: availableTypes)
                self.updateConnectionType(interface: availableTypes)
        }
    
    }
    
    
    func updateStatus(status: NWPath.Status,
                      interface: [NWInterface.InterfaceType]) {
        isNetworkAvailable = (status == .satisfied && !interface.isEmpty) ? true : false
        onUpdateNetworkStatus?(isNetworkAvailable)
    }
    
    func updateConnectionType(interface: [NWInterface.InterfaceType]) {
        connectionType = interface.first
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
