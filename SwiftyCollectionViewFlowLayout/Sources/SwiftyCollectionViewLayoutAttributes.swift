//
//  SwiftyCollectionViewLayoutAttributes.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import UIKit

public final class SwiftyCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    internal var sectionModel: SectionModel?
    internal weak var layout: SwiftyCollectionViewFlowLayout?
    
    public internal(set) var sizeMode: SwiftyCollectionViewFlowLayoutSizeMode = Default.sizeMode
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SwiftyCollectionViewLayoutAttributes
        copy.sizeMode = sizeMode
        copy.sectionModel = sectionModel
        copy.layout = layout
        return copy
    }
}
