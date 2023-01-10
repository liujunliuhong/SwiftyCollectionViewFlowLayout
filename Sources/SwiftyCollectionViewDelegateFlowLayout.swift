//
//  SwiftyCollectionViewDelegateFlowLayout.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/1/9.
//

import Foundation
import UIKit

public typealias SwiftyCollectionViewDelegateFlowLayout = SwiftyCollectionViewDelegateWaterFlowLayout & XXX

public protocol XXX: UICollectionViewDelegateFlowLayout {
    
}

public protocol SwiftyCollectionViewDelegateWaterFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        numberOfColumnsInSection section: Int) -> Int
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        columnSpacingForSectionAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SwiftyCollectionViewFlowLayout,
                        rowSpacingForSectionAt section: Int) -> CGFloat
}
