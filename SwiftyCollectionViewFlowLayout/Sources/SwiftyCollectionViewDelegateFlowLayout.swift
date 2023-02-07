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
                        itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewFlowLayoutSizeMode
    
    /// SectionInset
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    
    /// MinimumLineSpacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    /// MinimumInteritemSpacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    /// VisibilityMode for Header
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode
    
    /// VisibilityMode for Footer
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode
    
    /// Whether SectionInset contains Header, the default system SectionInset does not contain Header. Default false.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainHeader section: Int) -> Bool
    
    /// Whether SectionInset contains Footer, the default system SectionInset does not contain Footer. Default false.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainFooter section: Int) -> Bool
    
    /// VisibilityMode for Decoration.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        visibilityModeForDecorationInSection section: Int) -> SwiftyCollectionViewFlowLayoutDecorationVisibilityMode
    
    /// Decoration view extra inset. Default UIEdgeInsets.zero.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        decorationExtraInset section: Int) -> UIEdgeInsets
    
    /// The collection view calls this method when the collectionView contentSize change.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        contentSizeDidChange size: CGSize)
}

extension SwiftyCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               itemSizeModeAt indexPath: IndexPath) -> SwiftyCollectionViewFlowLayoutSizeMode {
        return Default.sizeMode
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return Default.sectionInset
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Default.minimumLineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Default.minimumInteritemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               visibilityModeForHeaderInSection section: Int) -> SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode {
        return Default.headerVisibilityMode
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               visibilityModeForFooterInSection section: Int) -> SwiftyCollectionViewFlowLayoutSupplementaryVisibilityMode {
        return Default.footerVisibilityMode
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
                               visibilityModeForDecorationInSection section: Int) -> SwiftyCollectionViewFlowLayoutDecorationVisibilityMode {
        return Default.decorationVisibilityMode
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               decorationExtraInset section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               contentSizeDidChange size: CGSize) { }
}
