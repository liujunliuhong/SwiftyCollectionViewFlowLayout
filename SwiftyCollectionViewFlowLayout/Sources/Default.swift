//
//  Default.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/7.
//

import Foundation
import UIKit

/// Default value.
internal struct Default {
    static let sectionType: SwiftyCollectionViewSectionType = .waterFlow(numberOfColumns: 1)
    static let sectionInset: UIEdgeInsets = .zero
    static let sectionInsetContainHeader: Bool = false
    static let sectionInsetContainFooter: Bool = false
    static let headerOffet: UIOffset = .zero
    static let footerOffet: UIOffset = .zero
    static let headerDirection: SwiftyCollectionViewLayoutSupplementaryDirection = .left
    static let footerDirection: SwiftyCollectionViewLayoutSupplementaryDirection = .left
    static let lineSpacing: CGFloat = 15.0
    static let interitemSpacing: CGFloat = 15.0
    static let backgroundVisibilityMode: SwiftyCollectionViewLayoutBackgroundVisibilityMode = .hidden
    static let backgroundInset: UIEdgeInsets = .zero
    static let sizeMode: SwiftyCollectionViewLayoutSizeMode = .default
    static let size: CGSize = CGSize(width: 50, height: 50)
    static let headerVisibilityMode: SwiftyCollectionViewLayoutSupplementaryVisibilityMode = .hidden
    static let footerVisibilityMode: SwiftyCollectionViewLayoutSupplementaryVisibilityMode = .hidden
    static let headerPinToVisibleBounds: Bool = false
    static let footerPinToVisibleBounds: Bool = false
    static let metrics: SectionMetrics = SectionMetrics.default
    static let scale: CGFloat = 3.0
}

