//
//  SwiftyCollectionViewDelegateFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit

public protocol SwiftyCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    /// SectionType
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionType section: Int) -> SwiftyCollectionViewSectionType
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainHeader section: Int) -> Bool
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainFooter section: Int) -> Bool
    
    /// Whether to display decoration view
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        decorationViewDisplay section: Int) -> Bool
    
    /// Decoration view extra attributes
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        decorationExtraAttributes section: Int) -> SwiftyCollectionViewLayoutDecorationExtraAttributes?
    
    /// Decoration view extra inset
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
