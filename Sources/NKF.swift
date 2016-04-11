//
//  NKF.swift
//  NKF
//
//  Created by ito on 12/27/15.
//  Copyright © 2015 Yusuke Ito. All rights reserved.
//

import CNKF

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
    
    private static func convert(src: CFData, options: String) -> (CFData, Int) {
        var outLength: CFIndex = 0
        let out = Sync {
            cf_nkf_convert(src, options, &outLength)
        }
        return (out, outLength)
    }
    
    private static func convert(src: CFData, options: String) -> String? {
        let out = Sync {
            cf_nkf_convert_to_utf8(src, options) as String?
        }
        return out
    }
    
    public static func convert(src: CFData, options: Option = []) -> String? {
        var newOptions = options
        newOptions.insert(.ToUTF8)
        return convert(src, options: newOptions.argValue)
    }
    
    public static func guess(src: CFData) -> Encoding? {
        let out = Sync {
            cf_nkf_guess(src) as String?
        }
        guard let code = out else {
            return nil
        }
        return Encoding(rawValue: code)
    }
}