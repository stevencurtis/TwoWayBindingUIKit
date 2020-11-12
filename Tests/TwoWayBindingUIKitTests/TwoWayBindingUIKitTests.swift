import XCTest
import UIKit
@testable import TwoWayBindingUIKit

final class TwoWayBindingUIKitTests: XCTestCase {
    
    func testMakeBinding() {
        let expectation = XCTestExpectation(description: #function)
        let text = MakeBindable("tests")
        let testTF = TestTF()
        var results: [String] = []

        testTF.closure = {str in
            results.append(str)
            if results.count == 2 {
                XCTAssertEqual(results, ["tests", "test"])
                expectation.fulfill()
            }
        }
        text.bind(\String.self, to: testTF, \.text)

        text.update(with: "test")
        wait(for: [expectation], timeout: 3.0)
    }
    
}
