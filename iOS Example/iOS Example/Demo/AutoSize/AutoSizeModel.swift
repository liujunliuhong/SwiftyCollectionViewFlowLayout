//
//  AutoSizeModel.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/7.
//

import Foundation
import SwiftyCollectionViewFlowLayout

public class AutoSizeSectionModel {
    public let headerTitle: String
    public let footerTitle: String
    public let items: [AutoSizeItemModel]
    
    public let sectionType: SwiftyCollectionViewSectionType
    
    public init(headerTitle: String, footerTitle: String, items: [AutoSizeItemModel], sectionType: SwiftyCollectionViewSectionType) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.items = items
        self.sectionType = sectionType
    }
}

public class AutoSizeItemModel {
    public let title: String
    public let width: CGFloat
    public let height: CGFloat
    
    public init(title: String, width: CGFloat, height: CGFloat) {
        self.title = title
        self.width = width
        self.height = height
    }
}
