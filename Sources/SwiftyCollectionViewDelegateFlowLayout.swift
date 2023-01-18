//
//  SwiftyCollectionViewDelegateFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit

public typealias SwiftyCollectionViewDelegateFlowLayout = SwiftyCollectionViewDelegateWaterFlowLayout & SwiftyCollectionViewDelegateBasicFlowLayout





public protocol SwiftyCollectionViewDelegateBasicFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainHeader section: Int) -> Bool
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        sectionInsetContainFooter section: Int) -> Bool
}








public protocol SwiftyCollectionViewDelegateWaterFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        numberOfColumnsInSection section: Int) -> Int
}

extension SwiftyCollectionViewDelegateWaterFlowLayout {
    
}
