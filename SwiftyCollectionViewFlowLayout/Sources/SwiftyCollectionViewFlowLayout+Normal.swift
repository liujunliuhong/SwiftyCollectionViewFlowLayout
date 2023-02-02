//
//  SwiftyCollectionViewFlowLayout+Normal.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/1.
//

import Foundation
import UIKit

extension SwiftyCollectionViewFlowLayout {
    internal func _layoutNormalAttributesForItem(at indexPath: IndexPath) {
        guard let _ = collectionView else { return }
        guard let sectionModel = sectionModels[indexPath.section] else { return }
        guard let cellAttr = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return }
        // Use system item frame
        // Update Section Model
        sectionModel.itemLayoutAttributes.append(cellAttr)
    }
}
