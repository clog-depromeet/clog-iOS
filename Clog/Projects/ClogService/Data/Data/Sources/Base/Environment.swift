//
//  Environment.swift
//  Data
//
//  Created by Junyoung on 3/24/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

enum Environment {
    static var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "baseURL") as? String ?? ""
    }
}
