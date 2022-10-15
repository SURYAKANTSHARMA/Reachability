//
//  ReachabilityManagerTests2.swift
//  ReachabilityTests
//
//  Created by Rapido on 10/10/22.
//

import Foundation
import XCTest
import Network

protocol NwPathMonitorInterace {
     var pathUpdateHandler: ((_ newPath: NWPath) -> Void)? {set get}
}

class ReachabilityManager2 {
    var isConnected: Bool = false
    let monitor: NwPathMonitorInterace
    
    // Dependency Injection principle
    init(monitor: NwPathMonitorInterace) {
        self.monitor = monitor
        
    }
    
    func startMonitoring() {
    }
}

// Red() -> Green  -> think you can refactor
class ReachabilityManagerTests2: XCTestCase {
    // FIRST
    func test_reachabilityManager_shouldHaveConnectionFalseByDefault() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.isConnected, false)
    }
    
    func test_reachabilityManager_monitorFunction_shouldCallInterfaceFunction() {
        let sut = makeSUT()
        let monitor =
        sut.startMonitoring()
        
        
    
    }
    
    func makeSUT(monitor: NwPathMonitorInterace = NwPathMonitorSpy()
    ) -> ReachabilityManager2 {
        ReachabilityManager2(monitor: monitor)
    }

}

struct NwPathMonitorSpy: NwPathMonitorInterace {
    
    var pathUpdateHandler: ((_ newPath: NWPath) -> Void)?
}
