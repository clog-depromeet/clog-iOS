//
//  VideoFeatureAssembly.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Swinject

import Domain
import VideoDomain

public struct VideoFeatureAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Swinject.Container) {
        
        container.register(VideoUseCase.self) { resolver in
            
            guard let videospository = resolver.resolve(VideoRepository.self) else {
                fatalError("Could not resolve CaptureRepository")
            }
            
            return VideoUploadUsesCase(
                videoRepository: videospository
            )
        }
        
        container.register(VideoFeature.self) { resolver in
            return VideoFeature(permission: VideoPermissionHandler())
        }
        
        container.register(RecordHomeFeature.self) { resolver in
            return RecordHomeFeature()
        }
    }
    
}
