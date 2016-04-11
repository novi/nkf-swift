//
//  Options.swift
//  NKF
//
//  Created by Yusuke Ito on 4/11/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//


extension NKF {
    public struct Option: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        // TODO: implement other options
        static let ToUTF8 = Option(rawValue: 1 << 0)
        
        var argValue: String {
            var argValue = ""
            if contains(.ToUTF8) {
                argValue += "-w"
            }
            return argValue
        }
    }
}