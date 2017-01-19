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
    
    private static func convert(src: UnsafePointer<UInt8>, length: Int, options: Option) -> (UnsafeMutablePointer<UInt8>, Int) {
        var outLength: CFIndex = 0
        let out = Sync {
            cf_nkf_convert(src, length, options.argValue, &outLength)
        }
        return (out!, outLength)
    }
    
    public static func convert(src: UnsafePointer<UInt8>, length: Int, options: Option = []) -> String? {
        var newOptions = options
        _ = newOptions.insert(.toUTF8)
        
        let out: (UnsafeMutablePointer<UInt8>, Int) = convert(src: src, length: length, options: newOptions)
        defer {
            free(out.0)
        }
        let ptr = unsafeBitCast(out.0, to: UnsafePointer<CChar>.self)
        if options.contains(.strict) {
            return String(validatingUTF8: ptr)
        } else {
            return String(cString: ptr)
        }
    }
    
    public static func convert(data srcData: Data, options: Option = []) -> String? {
        return srcData.withUnsafeBytes({ (ptr: UnsafePointer<UInt8>) in
            self.convert(src: ptr, length: srcData.count, options: options)
        })
    }
    
    public static func convert(data srcData: NSData, options: Option = []) -> String? {
        return self.convert(src: unsafeBitCast(srcData.bytes, to: UnsafePointer<UInt8>.self), length: srcData.length, options: options)
    }
    
    public static func guess(src: UnsafePointer<UInt8>, length: Int) -> Encoding? {
        let out = Sync {
            cf_nkf_guess(src, length)
        }
        
        guard let codePtr = out, let code = String(validatingUTF8: codePtr) else {
            return nil
        }
        return Encoding(rawValue: code)
    }
    
    public static func guess(data src: Data) -> Encoding? {
        return src.withUnsafeBytes({ (ptr: UnsafePointer<UInt8>) in
            guess(src: ptr, length: src.count)
        })
    }
    
    public static func guess(data src: NSData) -> Encoding? {
        return guess(src: unsafeBitCast(src.bytes, to: UnsafePointer<UInt8>.self), length: src.length)
    }
}
