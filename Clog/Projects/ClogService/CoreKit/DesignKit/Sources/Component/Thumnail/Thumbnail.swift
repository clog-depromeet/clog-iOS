//
//  Thumbnail.swift
//  DesignKit
//
//  Created by Junyoung on 4/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import SwiftUI

public struct Thumbnail: View {
    
    private let url: String?
    private let height: CGFloat?
    private let width: CGFloat?
    
    public init(
        url: String?,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self.url = url
        self.width = width
        self.height = height
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            if let url {
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 60, height: 60)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        errorView
                    @unknown default:
                        errorView
                    }
                }
            } else {
                ClogUI.basicThumbnail
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: width, height: height)
        .background(Color.clogUI.gray700)
    }
}

extension Thumbnail {
    private var errorView: some View {
        Image.clogUI.alert
            .resizable()
            .foregroundStyle(Color.clogUI.gray50)
    }
}

#Preview {
    Thumbnail(url: "https://fastly.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI", width: 166, height: 166)
    
    Thumbnail(url: "https://fastly.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI", width: 100, height: 100)
    
    Thumbnail(url: "https://fastly.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI", width: 250, height: 250)
}
