//
//  SwiftyCollectionViewDelegateFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit

public typealias SwiftyCollectionViewDelegateFlowLayout = SwiftyCollectionViewDelegateWaterFlowLayout & SwiftyCollectionViewDelegateBasicFlowLayout


//////////////////////////////////////////////////////////////////////////////////////////////////
public protocol SwiftyCollectionViewDelegateBasicFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionType section: Int) -> SwiftyCollectionViewSectionType
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainHeader section: Int) -> Bool
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainFooter section: Int) -> Bool
}

extension SwiftyCollectionViewDelegateBasicFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainHeader section: Int) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainFooter section: Int) -> Bool {
        return false
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////
public protocol SwiftyCollectionViewDelegateWaterFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        numberOfColumnsInSection section: Int) -> Int
}

extension SwiftyCollectionViewDelegateWaterFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        numberOfColumnsInSection section: Int) -> Int {
        return 1
    }
}
