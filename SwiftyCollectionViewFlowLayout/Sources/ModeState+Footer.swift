//
//  ModeState+Footer.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import UIKit


extension ModeState {
    internal func layoutFooterModel(at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        guard let footerModel = footerModel(at: section) else { return }
        
        let scrollDirection = layout().scrollDirection
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = footerModel.frame
        
        switch scrollDirection {
            case .vertical:
                frame.origin.x = .zero
                frame.origin.y = previousSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                if sectionModel.sectionInsetContainHeader {
                    frame.origin.x = sectionModel.sectionInset.left
                    frame.origin.y -= sectionModel.sectionInset.bottom
                }
            case .horizontal:
                frame.origin.x = previousSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                frame.origin.y = .zero
                if sectionModel.sectionInsetContainHeader {
                    frame.origin.x -= sectionModel.sectionInset.right
                    frame.origin.y = sectionModel.sectionInset.top
                }
            default:
                break
        }
        footerModel.frame = frame
    }
    
    internal func footerLayoutAttributes(at section: Int, frame: CGRect) -> UICollectionViewLayoutAttributes {
        let indexPath = IndexPath(item: 0, section: section)
        let attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
        attr.frame = frame
        return attr
    }
}
