//
//  AwesomeDaysTests.swift
//  AwesomeDaysTests
//
//  Created by Francesc Navarro on 17/8/21.
//

import XCTest
import Nimble

@testable import AwesomeDays

class AwesomeDaysTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        expect(1 + 1).to(equal(2))
    }
    
    func testDateFromYear() throws {
        let firstJanuary = "2021-01-01"
        var date = Date.fromYearMonthDayString(stringDate: firstJanuary)
        expect(date!.yearMonthDayString).to(equal(firstJanuary))
        
        let firstJanuaryNoZeros = "2021-1-1"
        date = Date.fromYearMonthDayString(stringDate: firstJanuaryNoZeros)
        expect(date!.yearMonthDayString).to(equal(firstJanuary), description: "Expect a date with prefixed zeros for single digit days and months (2021-01-01)")
        
        let twelfthAugust = "2021-08-12"
        date = Date.fromYearMonthDayString(stringDate: twelfthAugust)
        expect(date!.yearMonthDayString).to(equal(twelfthAugust))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
