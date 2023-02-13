//
//  ItemModel.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation

internal final class ItemModel {
    
    internal var sizeMode: SwiftyCollectionViewLayoutSizeMode
    
    internal var frame: CGRect = .zero
    
    internal init(sizeMode: SwiftyCollectionViewLayoutSizeMode) {
        self.sizeMode = sizeMode
        
        switch sizeMode.width {
            case .static(let w):
                switch sizeMode.height {
                    case .static(let h):
                        var frame = frame
                        frame.size.width = w
                        frame.size.height = h
                        self.frame = frame
                    case .dynamic, .fractionalFull, .full:
                        var frame = frame
                        frame.size.width = w
                        frame.size.height = Default.size.height
                        self.frame = frame
                }
            case .dynamic, .full, .fractionalFull:
                switch sizeMode.height {
                    case .static(let h):
                        var frame = frame
                        frame.size.width = Default.size.width
                        frame.size.height = h
                        self.frame = frame
                    case .dynamic, .fractionalFull, .full:
                        var frame = frame
                        frame.size.width = Default.size.width
                        frame.size.height = Default.size.height
                        self.frame = frame
                }
        }
    }
}
