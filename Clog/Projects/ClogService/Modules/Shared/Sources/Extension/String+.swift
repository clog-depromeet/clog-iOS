//
//  String+.swift
//  Shared
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public extension String {
    func toDate(
        format: String = "yyyy-MM-dd",
        timeZone: TimeZone = .current,
        locale: Locale = .current
    ) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }
}
