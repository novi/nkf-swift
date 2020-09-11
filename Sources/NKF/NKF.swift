//
//  NKF.swift
//  NKF
//
//  Created by ito on 12/27/15.
//  Copyright © 2015 Yusuke Ito. All rights reserved.
//

import CNKF
import Foundation

final public class NKF {
    
    private static func Sync<T>( block: () throws -> T) rethrows -> T {
        pthread_mutex_lock(&mutex)
        defer {
            pthread_mutex_unlock(&mutex)
        }
        let result = try block()
        return result
    }
    
    private static var mutex: pthread_mutex_t = {
        var m = pthread_mutex_t()
        pthread_mutex_init(&m, nil)
        return m
    }()
    
    private static func convert(src: UnsafeRawBufferPointer, length: Int, options: Option) -> (UnsafeMutablePointer<UInt8>, Int) {
        var outLength: CFIndex = 0
        let out = Sync {
            cf_nkf_convert(src.bindMemory(to: UInt8.self).baseAddress!, length, options.argValue, &outLength)
        }
        return (out!, outLength)
    }
    
    // MARK: Convert
    
    public static func convert(src: UnsafeRawBufferPointer, length: Int, options: Option = []) -> String? {
        var newOptions = options
        _ = newOptions.insert(.toUTF8)
        
        let out: (UnsafeMutablePointer<UInt8>, Int) = convert(src: src, length: length, options: newOptions)
        defer {
            free(out.0)
        }
        if out.1 == 0 {
            // empty data
            return nil
        }
        if out.1 == 1, out.0.pointee == 0 {
            // null string
            return nil
        }
        let ptr = UnsafeMutableRawPointer(out.0).assumingMemoryBound(to: CChar.self)
        if options.contains(.strict) {
            return String(validatingUTF8: ptr)
        } else {
            return String(bytesNoCopy: ptr, length: out.1 - 1, encoding: .utf8, freeWhenDone: false)
        }
    }
    
    public static func convert(src: UnsafeRawBufferPointer, length: Int, options: Option = []) -> NSData? {
        let out: (UnsafeMutablePointer<UInt8>, Int) = convert(src: src, length: length, options: options)
        if out.1 == 0 {
            // empty data
            return nil
        }
        if out.1 == 1, out.0.pointee == 0 {
            // null string
            return nil
        }
        return NSData(bytesNoCopy: out.0, length: out.1, freeWhenDone: true)
    }
    
    public static func convert(src: UnsafeRawBufferPointer, length: Int, options: Option = []) -> Data? {
        guard let data: NSData = convert(src: src, length: length, options: options) else {
            return nil
        }
        return data as Data
    }
    
    public static func convert(data srcData: Data, options: Option = []) -> String? {
        return srcData.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            convert(src: ptr, length: srcData.count, options: options)
        }
    }
    
    public static func convert(data srcData: Data, options: Option = []) -> NSData? {
        return srcData.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            convert(src: ptr, length: srcData.count, options: options)
        }
    }
    
    public static func convert(data srcData: Data, options: Option = []) -> Data? {
        return srcData.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            convert(src: ptr, length: srcData.count, options: options)
        }
    }
    
    public static func convert(data srcData: NSData, options: Option = []) -> String? {
        return convert(src: UnsafeRawBufferPointer(start: srcData.bytes, count: srcData.length), length: srcData.length, options: options)
    }
    
    public static func convert(data srcData: NSData, options: Option = []) -> NSData? {
        return convert(src: UnsafeRawBufferPointer(start: srcData.bytes, count: srcData.length), length: srcData.length, options: options)
    }
    
    public static func convert(data srcData: NSData, options: Option = []) -> Data? {
        return convert(src: UnsafeRawBufferPointer(start: srcData.bytes, count: srcData.length), length: srcData.length, options: options)
    }
    
    // MARK: Guess
    
    public static func guess(src: UnsafeRawBufferPointer, length: Int) -> Encoding? {
        let out = Sync {
            cf_nkf_guess(src.bindMemory(to: UInt8.self).baseAddress!, length)
        }
        
        guard let codePtr = out, let code = String(validatingUTF8: codePtr) else {
            return nil
        }
        return Encoding(rawValue: code)
    }
    
    public static func guess(data src: Data) -> Encoding? {
        return src.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            guess(src: ptr, length: src.count)
        }
    }
    
    public static func guess(data src: NSData) -> Encoding? {
        return guess(src: UnsafeRawBufferPointer(start: src.bytes, count: src.length), length: src.length)
    }
}
