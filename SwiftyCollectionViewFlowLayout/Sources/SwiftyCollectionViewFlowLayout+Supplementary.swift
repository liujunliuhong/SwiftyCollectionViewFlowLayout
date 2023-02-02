//
//  SwiftyCollectionViewFlowLayout+Supplementary.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/1.
//

import Foundation
import UIKit

extension SwiftyCollectionViewFlowLayout {
    internal func _layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) {
        guard let collectionView = collectionView else { return }
        guard let sectionModel = sectionModels[indexPath.section] else { return }
        
        let supplementaryViewAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            // Header
            let headerSize = mDelegate?.collectionView?(collectionView,
                                                        layout: self,
                                                        referenceSizeForHeaderInSection: indexPath.section) ?? .zero
            var header_x: CGFloat = .zero
            var header_y: CGFloat = .zero
            var header_width: CGFloat = .zero
            var header_height: CGFloat = .zero
            
            if scrollDirection == .vertical {
                header_x = .zero
                header_y = .zero
                header_width = collectionView.frame.width
                header_height = headerSize.height
            } else if scrollDirection == .horizontal {
                header_x = .zero
                header_y = .zero
                header_width = headerSize.width
                header_height = collectionView.frame.height
            }
            supplementaryViewAttr.frame = CGRect(x: header_x,
                                                 y: header_y,
                                                 width: header_width,
                                                 height: header_height)
            
            sectionModel.headerLayoutAttributes = supplementaryViewAttr
            
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            // Footer
            let footerSize = mDelegate?.collectionView?(collectionView,
                                                        layout: self,
                                                        referenceSizeForFooterInSection: indexPath.section) ?? .zero
            var footer_x: CGFloat = .zero
            var footer_y: CGFloat = .zero
            var footer_width: CGFloat = .zero
            var footer_height: CGFloat = .zero
            
            if scrollDirection == .vertical {
                footer_x = .zero
                footer_y = .zero
                footer_width = collectionView.frame.width
                footer_height = footerSize.height
            } else if scrollDirection == .horizontal {
                footer_x = .zero
                footer_y = .zero
                footer_width = footerSize.width
                footer_height = collectionView.frame.height
            }
            supplementaryViewAttr.frame = CGRect(x: footer_x,
                                                 y: footer_y,
                                                 width: footer_width,
                                                 height: footer_height)
            sectionModel.footerLayoutAttributes = supplementaryViewAttr
        }
    }
}
