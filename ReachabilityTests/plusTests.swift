//
//  plusTests.swift
//  ReachabilityTests
//
//  Created by Rapido on 10/10/22.
//

import Foundation

import XCTest

// old code written
//func plusFunction(_ a: Int, _ b: Int) -> Int {
//    a + b
//}
//

func plusfunc(_ a: Int, _ b: Int) -> Int {
    a + b
}

class PlusTest: XCTestCase {
    
    func test_plusFunction_shouldReturnCorrectOutput() {
        let output = plusfunc(2,2)
        
        XCTAssertEqual(output, 4)
    }
    
    
    func test_plusFunctionWithInput_3and3_shouldReturnOutput_6() {
        let output = plusfunc(3,3)

        XCTAssertEqual(output, 6)
    }

//
//    func test_plusFunctionWithInput_4and4_shouldReturnOutput_8() {
//        let output = plusfunc(3,3)
//
//        XCTAssertEqual(output, 6)
//    }
    
}


