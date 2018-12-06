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

final class NKFBasicTests: XCTestCase {
    
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
    
    func testShiftJISToUTF8Data() {
        let src = "日本語あいう123"
        //print("src",src)
        let sjis = src.data(using: .shiftJIS)!
        //print("data",eucjp)
        
        let out = NKF.convert(data: sjis, options: [.toUTF8]) as Data?
        let outString = out!.withUnsafeBytes { p in
            // out data is null-terminated
            return String(validatingUTF8: p)!
        }
        XCTAssertEqual(outString, src)
    }
    
    func testEUCJPToUTF8() {
        let src = "日本語あいう123"
        #if os(OSX)
            // TODO: failure in Linux
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
        XCTAssertEqual(out!, Encoding.utf8)
    }
    
    func testGuessSJIS() {
        let src = "日本語あいうえお123"
        let out = NKF.guess(data: src.data(using: .shiftJIS)!)
        XCTAssertEqual(out!, Encoding.shiftJIS)
    }
    
    func testGuessEUCJP() {
        let src = "日本語あいうえお123"
        #if os(OSX)
            // TODO: failure in Linux
            let eucjp = src.data(using: .japaneseEUC)!
        #else
            let srcBytes:[UInt8] = [0xc6, 0xfc, 0xcb, 0xdc, 0xb8, 0xec, 0xa4, 0xa2, 0xa4, 0xa4, 0xa4, 0xa6, 0x31, 0x32, 0x33] //"日本語あいう123"
            let eucjp = NSData(bytes: srcBytes, length: srcBytes.count)
        #endif
        let out = NKF.guess(data: eucjp)
        XCTAssertEqual(out!, Encoding.eucJP)
    }

    func testShortString() {
        let src = "0"
        
        let srcData = src.data(using: .shiftJIS)!
        let out = NKF.convert(data: srcData) as String?
        
        XCTAssertEqual(out!, src)
    }
    
    func testLargeString() {
        var src = ""
        for _ in 0...1000000 {
            src.append("1234567890あいうえお漢字")
        }
        let srcData = src.data(using: .shiftJIS)!
        print("src is", srcData.count, "bytes")
        let out = NKF.convert(data: srcData) as String?
        
        XCTAssertTrue(out == src)
    }
    
    func testEmptyString() {
        let src = ""
        
        let srcData = src.data(using: .shiftJIS)!
        let out = NKF.convert(data: srcData) as String?
        
        XCTAssertNil(out)
    }
    
    func testEmptyDataToData() {
        let out = NKF.convert(data: Data(), options: [.toUTF8]) as Data?
        XCTAssertNil(out)
    }
    
    func testInvalidInput() {
        
        let srcData = Data([0xff])
        let out = NKF.convert(data: srcData) as String?
        
        XCTAssertNil(out)
    }
    
    func testInvalidInputToData() {
        
        let srcData = Data([0xff])
        let out = NKF.convert(data: srcData) as NSData?
        
        XCTAssertNil(out)
    }
}
