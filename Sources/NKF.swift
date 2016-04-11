//
//  NKF.swift
//  NKF
//
//  Created by ito on 12/27/15.
//  Copyright © 2015 Yusuke Ito. All rights reserved.
//

import CNKF

extension String {
    private func toData() -> CFData {
        return withCString{ ptr in
            let cf = CFStringCreateWithCString(nil, ptr, CFStringBuiltInEncodings.UTF8.rawValue)
            return CFStringCreateExternalRepresentation(nil, cf, CFStringBuiltInEncodings.UTF8.rawValue, 0)
        }
    }
}

final public class NKF {
    
    private static func Sync<T>(@noescape block: () -> T) -> T {
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
    
    private static func convert(src: CFData, options: Option) -> (CFData, Int) {
        var outLength: CFIndex = 0
        let out = Sync {
            cf_nkf_convert(src, options.argValue.toData(), &outLength)
        }
        return (out, outLength)
    }
    
    public static func convert(src: CFData, options: Option = []) -> String? {
        var newOptions = options
        newOptions.insert(.ToUTF8)
        
        let out: (CFData, Int) = convert(src, options: newOptions)
        let ptr = unsafeBitCast(CFDataGetBytePtr(out.0), to: UnsafePointer<CChar>.self)
        if options.contains(.Strict) {
            return String(validatingUTF8: ptr)
        } else {
            return String(cString: ptr)
        }
    }
    
    public static func guess(src: CFData) -> Encoding? {
        let out = Sync {
            cf_nkf_guess(src)
        }
        if out == nil {
            return nil
        }
        
        guard let code = String(validatingUTF8: out) else {
            return nil
        }
        return Encoding(rawValue: code)
    }
}