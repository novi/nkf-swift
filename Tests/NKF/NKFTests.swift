//
//  NKFTests.swift
//  NKFTests
//
//  Created by ito on 12/27/15.
//  Copyright © 2015 Yusuke Ito. All rights reserved.
//

import XCTest
@testable import NKF

extension NKFTests {
    static var allTests : [(String, NKFTests -> () throws -> Void)] {
        return [
                   ("testUTF8ToUTF8", testUTF8ToUTF8),
                   ("testEUCJPToUTF8", testEUCJPToUTF8),
                   ("testGuessUTF8", testGuessUTF8),
                   ("testGuessSJIS", testGuessSJIS)
        ]
    }
}

class NKFTests: XCTestCase {
    
    func testUTF8ToUTF8() {
        let src = "日本語🍣あいうえお123"
        // let src = "日本語あいうえお123🍣" // TODO: will failure
        
        let srcData = src.data(usingEncoding: NSUTF8StringEncoding)!
        let out = NKF.convert(srcData) as String?
        
        XCTAssertEqual(out!, src)
    }
    
    func testEUCJPToUTF8() {
        let src = "日本語あいう123"
        let eucjp = src.data(usingEncoding: NSJapaneseEUCStringEncoding)!
        
        let out = NKF.convert(eucjp) as String?
        XCTAssertEqual(out!, src)
    }
    
    func testGuessUTF8() {
        let src = "日本語🍣あいうえお123"
        let out = NKF.guess(src.data(usingEncoding: NSUTF8StringEncoding)!)
        XCTAssertEqual(out!, Encoding.UTF8)
    }
    
    func testGuessSJIS() {
        let src = "日本語あいうえお123"
        let out = NKF.guess(src.data(usingEncoding: NSShiftJISStringEncoding)!)
        XCTAssertEqual(out!, Encoding.ShiftJIS)
    }
    
    
}
