import XCTest

extension NKFBasicTests {
    static let __allTests = [
        ("testEmptyDataToData", testEmptyDataToData),
        ("testEmptyString", testEmptyString),
        ("testEUCJPToUTF8", testEUCJPToUTF8),
        ("testGuessEUCJP", testGuessEUCJP),
        ("testGuessSJIS", testGuessSJIS),
        ("testGuessUTF8", testGuessUTF8),
        ("testInvalidInput", testInvalidInput),
        ("testInvalidInputToData", testInvalidInputToData),
        ("testLargeString", testLargeString),
        ("testShiftJISToUTF8", testShiftJISToUTF8),
        ("testShiftJISToUTF8Data", testShiftJISToUTF8Data),
        ("testShortString", testShortString),
        ("testUTF8ToUTF8", testUTF8ToUTF8),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NKFBasicTests.__allTests),
    ]
}
#endif
