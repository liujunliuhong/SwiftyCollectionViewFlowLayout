//
//  SwiftyCollectionViewDelegateFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit

public protocol SwiftyCollectionViewDelegateFlowLayout: UICollectionViewDelegate {
    /// Current section type.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionType section: Int) -> SwiftyCollectionViewSectionType
    
    /// ItemSize Mode
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewLayoutSizeMode
    
    /// SectionInset
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    
    /// LineSpacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        lineSpacingForSectionAt section: Int) -> CGFloat
    
    /// InteritemSpacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        interitemSpacingForSectionAt section: Int) -> CGFloat
    
    /// VisibilityMode for Header
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode
    
    /// VisibilityMode for Footer
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode
    
    /// Header Offset
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        headerOffset section: Int) -> UIOffset
    
    /// Footer Offset
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        footerOffset section: Int) -> UIOffset
    
    /// Header Direction
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        headerDirection section: Int) -> SwiftyCollectionViewLayoutSupplementaryDirection
    
    /// Footer Direction
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        footerDirection section: Int) -> SwiftyCollectionViewLayoutSupplementaryDirection
    
    /// Whether SectionInset contains Header, the default system SectionInset does not contain Header. Default false.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainHeader section: Int) -> Bool
    
    /// Whether SectionInset contains Footer, the default system SectionInset does not contain Footer. Default false.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainFooter section: Int) -> Bool
    
    /// VisibilityMode for Background.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        visibilityModeForBackgroundInSection section: Int) -> SwiftyCollectionViewLayoutBackgroundVisibilityMode
    
    /// Background view inset. Default UIEdgeInsets.zero.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        backgroundInset section: Int) -> UIEdgeInsets
    
    /// The collection view calls this method when the collectionView contentSize change.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        contentSizeDidChange size: CGSize)
}

extension SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewLayoutSizeMode {
        return Default.sizeMode
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return Default.sectionInset
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               lineSpacingForSectionAt section: Int) -> CGFloat {
        return Default.lineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               interitemSpacingForSectionAt section: Int) -> CGFloat {
        return Default.interitemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return Default.headerVisibilityMode
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewLayoutSupplementaryVisibilityMode {
        return Default.footerVisibilityMode
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               headerOffset section: Int) -> UIOffset {
        return Default.headerOffet
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               footerOffset section: Int) -> UIOffset {
        return Default.footerOffet
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               headerDirection section: Int) -> SwiftyCollectionViewLayoutSupplementaryDirection {
        return Default.headerDirection
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               footerDirection section: Int) -> SwiftyCollectionViewLayoutSupplementaryDirection {
        return Default.footerDirection
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               sectionInsetContainHeader section: Int) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               sectionInsetContainFooter section: Int) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               visibilityModeForBackgroundInSection section: Int) -> SwiftyCollectionViewLayoutBackgroundVisibilityMode {
        return Default.backgroundVisibilityMode
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               backgroundInset section: Int) -> UIEdgeInsets {
        return Default.backgroundInset
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               contentSizeDidChange size: CGSize) { }
}
