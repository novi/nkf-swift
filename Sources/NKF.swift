//
//  NKF.swift
//  NKF
//
//  Created by ito on 12/27/15.
//  Copyright © 2015 Yusuke Ito. All rights reserved.
//

import CNKF

final public class NKF {
    
    static func Sync<T>(@noescape block: () -> T) -> T {
        pthread_mutex_lock(mutex)
        let result = block()
        pthread_mutex_unlock(mutex)
        return result
    }
    
    static let mutex: UnsafeMutablePointer<pthread_mutex_t> = UnsafeMutablePointer.alloc(sizeof(pthread_mutex_t))
    
    static func convert(src: CFDataRef, options: String) -> (CFDataRef, Int) {
        var outLength: CFIndex = 0
        let out = Sync {
            cf_nkf_convert(src, options, &outLength)
        }
        return (out, outLength)
    }
    
    public static func convert(src: CFDataRef, options: String) -> String? {
        let out = Sync {
            cf_nkf_convert_to_utf8(src, options) as String?
        }
        return out
    }
    
    public static func guess(src: CFDataRef) -> Encoding? {
        let out = Sync {
            cf_nkf_guess(src) as String?
        }
        guard let code = out else {
            return nil
        }
        return Encoding(rawValue: code)
    }
}