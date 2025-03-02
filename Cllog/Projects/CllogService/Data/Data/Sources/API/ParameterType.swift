//
//  ParameterType.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink

enum ParameterType {
    case dictionary(Starlink.SafeDictionary<String, Any>)
    case encodable(Encodable)
}
