//
//  Default.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/7.
//

import Foundation
import UIKit

internal struct Default {
    static let sectionType: SwiftyCollectionViewSectionType = .waterFlow(numberOfColumns: 1)
    static let sectionInset: UIEdgeInsets = .zero
    static let sectionInsetContainHeader: Bool = false
    static let sectionInsetContainFooter: Bool = false
    static let minimumLineSpacing: CGFloat = 15.0
    static let minimumInteritemSpacing: CGFloat = 15.0
    static let decorationVisibilityMode: SwiftyCollectionViewFlowLayoutDecorationVisibilityMode = .hidden
    static let decorationExtraInset: UIEdgeInsets = .zero
    static let sizeMode: SwiftyCollectionViewFlowLayoutSizeMode = .zero
    static let headerVisibilityMode: SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode = .hidden
    static let footerVisibilityMode: SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode = .hidden
}

