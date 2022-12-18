//
//  ReachabilityViewAdaptorTests.swift
//  ReachabilityTests
//
//  Created by Surya on 07/10/22.
//

import Foundation
@testable import Reachability
import XCTest

class ReachabilityViewAdaptorTests: XCTestCase {
    
    func test_shouldTrigger_onNetworkAvailable_whenStatusIstrue() {
        var enableNetworkCallingCounter = 0
        let reachabilityViewAdaptor = ReachabilityViewAdaptor(
            onNetworkAvailable: {
                enableNetworkCallingCounter += 1
            }
        ,onNetworkUnavailable: {})
        
        reachabilityViewAdaptor.updateNetworkStatus(true)
        
        XCTAssertEqual(enableNetworkCallingCounter, 1)
    }
    
    
    func test_shouldTrigger_onNetworkUnavailable_whenStatusIsFalse() {
        var unavailableNetworkCallingCounter = 0
        let reachabilityViewAdaptor = ReachabilityViewAdaptor(
            onNetworkAvailable: {}
        ,onNetworkUnavailable: {
            unavailableNetworkCallingCounter += 1
        })
        reachabilityViewAdaptor.updateNetworkStatus(false)
        
        XCTAssertEqual(unavailableNetworkCallingCounter, 1)
    }
}
