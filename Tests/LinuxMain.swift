import XCTest
import NKFTestSuite

var tests = [XCTestCaseEntry]()

tests += NKFTestSuite.allTests()

XCTMain(tests)
