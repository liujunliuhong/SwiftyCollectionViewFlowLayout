//
//  SectionModel+WaterFlow.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import ObjectiveC

private var key: String = "com.galaxy.SwiftyCollectionViewFlowLayout.waterFlow"

extension SectionModel {
    internal var waterFlowBodyColumnLengths: [CGFloat] {
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &key) as? [CGFloat]) ?? []
        }
    }
    
    internal func resetWaterFlowBodyColumnLengths() {
        var bodyColumnLengths = waterFlowBodyColumnLengths
        for i in 0..<bodyColumnLengths.count {
            bodyColumnLengths[i] = .zero
        }
        waterFlowBodyColumnLengths = bodyColumnLengths
    }
}
