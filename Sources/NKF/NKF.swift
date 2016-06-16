//
//  NKF.swift
//  NKF
//
//  Created by ito on 12/27/15.
//  Copyright © 2015 Yusuke Ito. All rights reserved.
//

import CNKF
import CoreFoundation
import Foundation

extension String {
    private func toData() -> CFData {
        return withCString{ ptr in
            #if os(Linux)
            let cf = CFStringCreateWithCString(nil, ptr, CFStringEncoding(kCFStringEncodingUTF8))
            return CFStringCreateExternalRepresentation(nil, cf, CFStringEncoding(kCFStringEncodingUTF8), 0)
            #else
            let cf = CFStringCreateWithCString(nil, ptr, CFStringBuiltInEncodings.UTF8.rawValue)
            return CFStringCreateExternalRepresentation(nil, cf, CFStringBuiltInEncodings.UTF8.rawValue, 0)
            #endif
        }
    }
}

extension NSData {
    private func cfData() -> CFData {
        #if os(Linux)
            return unsafeBitCast(self, to: CFData.self)
        #else
            return self as CFData
        #endif
    }
}

final public class NKF {
    
    private static func Sync<T>( block: @noescape () -> T) -> T {
        pthread_mutex_lock(&mutex)
        let result = block()
        pthread_mutex_unlock(&mutex)
        return result
    }
    
    private static var mutex: pthread_mutex_t = {
        var m = pthread_mutex_t()
        pthread_mutex_init(&m, nil)
        return m
    }()
    
    private static func convert(data srcData: CFData, options: Option) -> (Unmanaged<CFData>, Int) {
        var outLength: CFIndex = 0
        #if os(Linux)
        let out: Unmanaged<CFData> = Sync {
            let ptr = unsafeBitCast(cf_nkf_convert(srcData, options.argValue.toData(), &outLength), to: UnsafePointer<Void>.self)
            return Unmanaged.fromOpaque(ptr)
        }
        #else
        let out = Sync {
            Unmanaged.passRetained(cf_nkf_convert(srcData, options.argValue.toData(), &outLength))
        }
        #endif
        return (out, outLength)
    }
    
    public static func convert(data srcData: CFData, options: Option = []) -> String? {
        var newOptions = options
        _ = newOptions.insert(.toUTF8)
        
        let out: (Unmanaged<CFData>, Int) = convert(data: srcData, options: newOptions)
        defer {
            out.0.release()
        }
        let ptr = unsafeBitCast(CFDataGetBytePtr(out.0.takeUnretainedValue()), to: UnsafePointer<CChar>.self)
        if options.contains(.strict) {
            return String(validatingUTF8: ptr)
        } else {
            return String(cString: ptr)
        }
    }
    
    public static func convert(data srcData: NSData, options: Option = []) -> String? {
        return self.convert(data: srcData.cfData(), options: options)
    }
    
    public static func guess(data src: CFData) -> Encoding? {
        let out = Sync {
            cf_nkf_guess(src)
        }
        
        guard let codePtr = out, let code = String(validatingUTF8: codePtr) else {
            return nil
        }
        return Encoding(rawValue: code)
    }
    
    public static func guess(data src: NSData) -> Encoding? {
        return guess(data: src.cfData())
    }
}
