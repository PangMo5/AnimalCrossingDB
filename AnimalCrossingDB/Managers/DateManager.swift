//
//  DateManager.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/11.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var adjustTimeInterval: DefaultsKey<TimeInterval?> { return .init("adjustTimeInterval", defaultValue: nil) }
}

final class DateManager {
    
    static let shared = DateManager()
    
    var initDate = Date(timeIntervalSince1970: 1584709200)
    
    var adjustDate: Date? {
        didSet {
            guard let adjustDate = adjustDate else {
                Defaults[\.adjustTimeInterval] = nil
                return
            }
            Defaults[\.adjustTimeInterval] = adjustDate.timeIntervalSince(Date())
        }
    }
    
    var currentDate: Date {
        guard let timeInterval = Defaults[\.adjustTimeInterval] else { return Date() }
        return Date().addingTimeInterval(timeInterval)
    }
}
