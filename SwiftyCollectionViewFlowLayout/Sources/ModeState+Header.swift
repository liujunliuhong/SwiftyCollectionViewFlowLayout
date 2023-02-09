//
//  ModeState+Header.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import UIKit


extension ModeState {
    internal func layoutHeaderModel(at section: Int) {
        guard let layout = layout else { return }
        guard let sectionModel = sectionModel(at: section) else { return }
        guard let headerModel = headerModel(at: section) else { return }
        
        let scrollDirection = layout.scrollDirection
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = headerModel.frame
        
        switch scrollDirection {
            case .vertical:
                var width = layout.mCollectionView.bounds.width
                if sectionModel.sectionInsetContainHeader {
                    width -= (sectionModel.sectionInset.left + sectionModel.sectionInset.right)
                }
                frame.size.width = width
                
                frame.origin.x = .zero
                frame.origin.y = previousSectionTotalLength
                if sectionModel.sectionInsetContainHeader {
                    frame.origin.x = sectionModel.sectionInset.left
                    frame.origin.y += sectionModel.sectionInset.top
                }
                
                // reset sizeMode.width
                headerModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: .static(length: frame.width), height: headerModel.sizeMode.height)
                
            case .horizontal:
                var height = layout.mCollectionView.bounds.height
                if sectionModel.sectionInsetContainHeader {
                    height -= (sectionModel.sectionInset.top + sectionModel.sectionInset.bottom)
                }
                
                frame.size.height = height
                
                frame.origin.x = previousSectionTotalLength
                frame.origin.y = .zero
                if sectionModel.sectionInsetContainHeader {
                    frame.origin.x += sectionModel.sectionInset.left
                    frame.origin.y = sectionModel.sectionInset.top
                }
                
                // reset sizeMode.height
                headerModel.sizeMode = SwiftyCollectionViewFlowLayoutSizeMode(width: headerModel.sizeMode.width, height: .static(length: frame.height))
                
            default:
                break
        }
        headerModel.frame = frame
    }
    
    internal func headerLayoutAttributes(at section: Int, frame: CGRect) -> UICollectionViewLayoutAttributes {
        let sizeMode = headerModel(at: section)?.sizeMode ?? Default.sizeMode
        let indexPath = IndexPath(item: 0, section: section)
        let attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
        attr.sizeMode = sizeMode
        attr.frame = frame
        return attr
    }
}
