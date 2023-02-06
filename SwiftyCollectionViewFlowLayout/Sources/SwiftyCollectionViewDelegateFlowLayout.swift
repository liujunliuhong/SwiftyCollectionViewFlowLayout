//
//  SwiftyCollectionViewDelegateFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit

public protocol SwiftyCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    /// Current section type.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionType section: Int) -> SwiftyCollectionViewSectionType
    
    /// Whether SectionInset contains Header, the default system SectionInset does not contain Header. Default false.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainHeader section: Int) -> Bool
    
    /// Whether SectionInset contains Footer, the default system SectionInset does not contain Footer. Default false.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainFooter section: Int) -> Bool
    
    /// Whether to display decoration view. Default false.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        decorationViewDisplay section: Int) -> Bool
    
    /// Decoration view extra attributes. Default nil.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        decorationExtraAttributes section: Int) -> SwiftyCollectionViewLayoutDecorationExtraAttributes?
    
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
                               decorationViewDisplay section: Int) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                               decorationExtraAttributes section: Int) -> SwiftyCollectionViewLayoutDecorationExtraAttributes? {
        return nil
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
