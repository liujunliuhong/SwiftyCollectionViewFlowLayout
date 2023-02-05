//
//  DecorationExtraAttributes.swift
//  iOS Example
//
//  Created by galaxy on 2023/2/5.
//

import UIKit
import SwiftyCollectionViewFlowLayout

public final class DecorationExtraAttributes: SwiftyCollectionViewLayoutDecorationExtraAttributes {
    public var cornerRadius: CGFloat = .zero
    public var backgroundColor: UIColor = .purple
    
    public override init() {
        super.init()
    }
}
