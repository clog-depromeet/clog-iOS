//
//  StarlinkDelegate.swift
//  Starlink
//
//  Created by saeng lin on 2/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Pulse

internal final class StarlinkDelegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        NetworkLogger.shared.logDataTask(dataTask, didReceive: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        NetworkLogger.shared.logTask(task, didFinishCollecting: .init(metrics: metrics))
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        NetworkLogger.shared.logTask(task, didCompleteWithError: error)
    }
}
