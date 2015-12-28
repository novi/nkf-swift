//
//  NKFTests.swift
//  NKFTests
//
//  Created by ito on 12/27/15.
//  Copyright © 2015 Yusuke Ito. All rights reserved.
//

import XCTest
@testable import NKF

class NKFTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUTF8ToUTF8() {
        let src = "日本語🍣あいうえお123"
        // let src = "日本語あいうえお123🍣" // TODO: will failure
        
        let srcData = src.dataUsingEncoding(NSUTF8StringEncoding)!
        let out = NKF.convert(srcData, options: "-w") as String?
        
        XCTAssertEqual(out!, src)
    }
    
    func testGuessUTF8() {
        let src = "日本語🍣あいうえお123"
        let out = NKF.guess(src.dataUsingEncoding(NSUTF8StringEncoding)!)
        XCTAssertEqual(out!, Encoding.UTF8)
    }
    
    func testGuessSJIS() {
        let src = "日本語あいうえお123"
        let out = NKF.guess(src.dataUsingEncoding(NSShiftJISStringEncoding)!)
        XCTAssertEqual(out!, Encoding.ShiftJIS)
    }
    
    
}
