//
//  UILabel+.swift
//  DesignKit
//
//  Created by Junyoung on 2/26/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import SwiftUI

// MARK: - UIKit
public class ClLogLabel: UILabel {
    var title: String
    var fontModel: FontModel
    
    public init(
        title: String,
        fontModel: FontModel
    ) {
        self.title = title
        self.fontModel = fontModel
        super.init(frame: .zero)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configuration() {
        guard let font = UIFont(name: fontModel.font.rawValue, size: fontModel.size) else {
            fatalError("❌ 폰트 파일을 찾을 수 없음: \(fontModel.font.rawValue)")
        }
        
        let style = NSMutableParagraphStyle()
        let lineHeight = fontModel.size * fontModel.lineHeight
        let baselineOffset = (lineHeight - (font.ascender - font.descender)) / 2
        
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        style.alignment = self.textAlignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: style,
            .baselineOffset: baselineOffset
        ]
        let attrString = NSAttributedString(string: title,
                                            attributes: attributes)
        
        self.attributedText = attrString
        self.lineBreakMode = .byWordWrapping
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: size.height)
    }
}

// MARK: - SwiftUI
public struct ClLogLabelView: UIViewRepresentable {
    private let title: String
    private let fontModel: FontModel

    public init(
        title: String,
        fontModel: FontModel
    ) {
        self.title = title
        self.fontModel = fontModel
    }
    
    public func makeUIView(context: Context) -> ClLogLabel {
        
        let label = ClLogLabel(title: title, fontModel: fontModel)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }

    public func updateUIView(_ uiView: ClLogLabel, context: Context) {
        uiView.title = title
        uiView.fontModel = fontModel
        uiView.configuration()
    }
}
