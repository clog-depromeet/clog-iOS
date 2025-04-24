//
//  LocationError.swift
//  ClogService
//
//  Created by soi on 4/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public enum LocationError: Error {
    case noPermission
    case failedToFetch
}
