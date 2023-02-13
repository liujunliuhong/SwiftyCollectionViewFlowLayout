//
//  SectionModel+WaterFlow.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import ObjectiveC

private var key: String = "com.galaxy.SwiftyCollectionViewFlowLayout.water-flow"

extension SectionModel {
    internal var waterFlowBodyColumnLengths: [CGFloat] {
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &key) as? [CGFloat]) ?? []
        }
    }
}
