//
//  FooterModel.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation

internal final class FooterModel {
    
    internal var correctSizeMode: InternalSizeMode
    
    internal var frame: CGRect = .zero
    internal var pinnedFrame: CGRect = .zero
    
    internal init(correctSizeMode: InternalSizeMode) {
        self.correctSizeMode = correctSizeMode
        
        switch correctSizeMode.width {
            case .absolute(let w):
                switch correctSizeMode.height {
                    case .absolute(let h):
                        var frame = frame
                        frame.size.width = w
                        frame.size.height = h
                        self.frame = frame
                    case .dynamic, .ratio:
                        var frame = frame
                        frame.size.width = w
                        frame.size.height = Default.size.height
                        self.frame = frame
                }
            case .dynamic, .ratio:
                switch correctSizeMode.height {
                    case .absolute(let h):
                        var frame = frame
                        frame.size.width = Default.size.width
                        frame.size.height = h
                        self.frame = frame
                    case .dynamic, .ratio:
                        var frame = frame
                        frame.size.width = Default.size.width
                        frame.size.height = Default.size.height
                        self.frame = frame
                }
        }
    }
}
