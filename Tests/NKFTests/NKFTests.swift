//
//  NKFTests.swift
//  NKFTests
//
//  Created by ito on 12/27/15.
//  Copyright © 2015 Yusuke Ito. All rights reserved.
//

import XCTest
@testable import NKF
import Foundation

extension NKFBasicTests {
    static var allTests : [(String, (NKFBasicTests) -> () throws -> Void)] {
        return [
                   ("testUTF8ToUTF8", testUTF8ToUTF8),
                   ("testShiftJISToUTF8", testShiftJISToUTF8),
                   ("testEUCJPToUTF8", testEUCJPToUTF8),
                   ("testGuessUTF8", testGuessUTF8),
                   ("testGuessSJIS", testGuessSJIS),
                   ("testGuessEUCJP", testGuessEUCJP),
                   ("testShortString", testShortString)
        ]
    }
}

#if !os(macOS)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase( NKFBasicTests.allTests ),
        ]
    }
#endif

class NKFBasicTests: XCTestCase {
    
    func testUTF8ToUTF8() {
        let src = "日本語🍣あいうえお123"
        // let src = "日本語あいうえお123🍣" // TODO: will failure
        
        let srcData = src.data(using: .utf8)!
        let out = NKF.convert(data: srcData) as String?
        
        XCTAssertEqual(out!, src)
    }
    
    func testShiftJISToUTF8() {
        let src = "日本語あいう123"
        //print("src",src)
        let sjis = src.data(using: .shiftJIS)!
        //print("data",eucjp)
        
        let out = NKF.convert(data: sjis) as String?
        XCTAssertEqual(out!, src)
    }
    
    func testEUCJPToUTF8() {
        let src = "日本語あいう123"
        #if os(OSX)
            // TODO: fail in Linux
            let eucjp = src.data(using: .japaneseEUC)!
        #else
            let srcBytes:[UInt8] = [0xc6, 0xfc, 0xcb, 0xdc, 0xb8, 0xec, 0xa4, 0xa2, 0xa4, 0xa4, 0xa4, 0xa6, 0x31, 0x32, 0x33] //"日本語あいう123"
            let eucjp = NSData(bytes: srcBytes, length: srcBytes.count)
        #endif
        
        let out = NKF.convert(data: eucjp) as String?
        XCTAssertEqual(out!, src)
    }
    
    func testGuessUTF8() {
        let src = "日本語🍣あいうえお123"
        let out = NKF.guess(data: src.data(using: .utf8)!)
        XCTAssertEqual(out!, Encoding.UTF8)
    }
    
    func testGuessSJIS() {
        let src = "日本語あいうえお123"
        let out = NKF.guess(data: src.data(using: .shiftJIS)!)
        XCTAssertEqual(out!, Encoding.ShiftJIS)
    }
    
    func testGuessEUCJP() {
        let src = "日本語あいうえお123"
        #if os(OSX)
            // TODO: fail in Linux
            let eucjp = src.data(using: .japaneseEUC)!
        #else
            let srcBytes:[UInt8] = [0xc6, 0xfc, 0xcb, 0xdc, 0xb8, 0xec, 0xa4, 0xa2, 0xa4, 0xa4, 0xa4, 0xa6, 0x31, 0x32, 0x33] //"日本語あいう123"
            let eucjp = NSData(bytes: srcBytes, length: srcBytes.count)
        #endif
        let out = NKF.guess(data: eucjp)
        XCTAssertEqual(out!, Encoding.EUCJP)
    }

    func testShortString() {
        let src = "OK"
        
        let srcData = src.data(using: .utf8)!
        let out = NKF.convert(data: srcData) as String?
        
        XCTAssertEqual(out!, src)
        
    }
    
}
