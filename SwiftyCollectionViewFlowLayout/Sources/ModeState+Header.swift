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
        guard let sectionModel = sectionModel(at: section) else { return }
        guard let headerModel = headerModel(at: section) else { return }
        
        let scrollDirection = layout().scrollDirection
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = headerModel.frame
        
        switch scrollDirection {
            case .vertical:
                frame.origin.x = .zero
                frame.origin.y = previousSectionTotalLength
                if sectionModel.sectionInsetContainHeader {
                    frame.origin.x = sectionModel.sectionInset.left
                    frame.origin.y += sectionModel.sectionInset.top
                }
            case .horizontal:
                frame.origin.x = previousSectionTotalLength
                frame.origin.y = .zero
                if sectionModel.sectionInsetContainHeader {
                    frame.origin.x += sectionModel.sectionInset.left
                    frame.origin.y = sectionModel.sectionInset.top
                }
            default:
                break
        }
        headerModel.frame = frame
    }
    
    internal func headerLayoutAttributes(at section: Int, frame: CGRect) -> UICollectionViewLayoutAttributes {
        let indexPath = IndexPath(item: 0, section: section)
        let attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
        attr.frame = frame
        return attr
    }
}
