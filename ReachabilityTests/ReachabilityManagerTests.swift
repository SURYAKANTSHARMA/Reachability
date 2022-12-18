//
//  ReachabilityManagerTests.swift
//  ReachabilityManagerTests
//
//  Created by Surya on 06/10/22.
//

import XCTest
import Network
@testable import Reachability

class ReachabilityManagerTests: XCTestCase {
   
    func test_networkManager_should_init_withDefaultConnected_valueFalse() {
        let networkManager = makeSUT()
        XCTAssertFalse(networkManager.isNetworkAvailable)
    }
    
    
    func test_startMonitoring_shouldCallStartMonitoring_onqueue() {
        let monitorSpy = MonitorSpy()
        let queue = DispatchQueue.main
        let networkManager = makeSUT(monitor: monitorSpy,
                                     queue: queue)
        
        networkManager.startMonitoring()
        
        XCTAssertEqual(monitorSpy.startCallingCounter, 1)
        XCTAssertEqual(monitorSpy.startCallSink, queue)
        
        XCTAssertNotNil(monitorSpy.pathUpdateHandler)
    }
    
    
    func test_onUpdatingStatusSatisfied_shouldUpdateConnectionStatusToTrue() {
        let networkManager = makeSUT()
        networkManager.updateStatus(status: NWPath.Status.satisfied)
        
        XCTAssertEqual(networkManager.isNetworkAvailable, true)
    }
    
    func test_onUpdatingStatusUnSatisfied_shouldUpdateConnectionStatusToFalse() {
        let networkManager = makeSUT()
        networkManager.updateStatus(status: NWPath.Status.unsatisfied)
        
        XCTAssertEqual(networkManager.isNetworkAvailable, false)
    }
    
    func test_updateConnectionType_shouldSetFirstConnectionInPriority() {
        let networkManager = makeSUT()

        networkManager.startMonitoring()
        networkManager.updateConnectionType(interface: [
            .wiredEthernet,
            .wifi,
            .cellular
        ])

        XCTAssertEqual(networkManager.connectionType, .wiredEthernet)
    }

    
    func test_updateConnectionTypeToCellular_shouldSetConnectionTypeCellular() {
        let networkManager = makeSUT()

        networkManager.updateConnectionType(interface: [
            .cellular,
            .wiredEthernet,
            .wifi
        ])
        XCTAssertEqual(networkManager.connectionType, .cellular)
    }
    
    func test_onStatusUpdate_shouldCalledObservers() {
        let networkManager = makeSUT()
        let expectation = XCTestExpectation(description: "")

        networkManager.onUpdateNetworkStatus = { status in
            XCTAssertTrue(status)
            expectation.fulfill()
        }
        
        networkManager.updateStatus(status: .satisfied)
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_onStatusUnsatisfied_shouldCalledObserversWithFalseValue() {
        let networkManager = makeSUT()
        let expectation = XCTestExpectation(description: "")

        networkManager.onUpdateNetworkStatus = { status in
            XCTAssertFalse(status)
            expectation.fulfill()
        }
        
        networkManager.updateStatus(status: .unsatisfied)
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func test_stopMonitoring_shouldCancelMonitorUpdates() {
        let monitorySpy = MonitorSpy()
        let networkManager = makeSUT(monitor: monitorySpy)
        
        networkManager.stopMonitoring()
        
        XCTAssertEqual(monitorySpy.cancelCounter, 1)
    }
    
}


private func makeSUT(monitor: NWPathMonitorInterface
                     = MonitorSpy(),
                     queue: DispatchQueue =
                     DispatchQueue.global(qos: .default)) -> ReachabilityManager {
    ReachabilityManager(monitor: monitor, queue: queue)
}

private class MonitorSpy: NWPathMonitorInterface {
    
    var startCallingCounter = 0
    var startCallSink: DispatchQueue?
    
    var cancelCounter = 0
    var pathUpdateHandler: ((_ newPath: NWPath) -> Void)?
    
    func start(queue: DispatchQueue) {
        startCallingCounter += 1
        startCallSink = queue
    }
    
    func cancel() {
        cancelCounter += 1
    }
}


