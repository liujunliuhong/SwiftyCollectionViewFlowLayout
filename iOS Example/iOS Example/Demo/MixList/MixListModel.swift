//
//  MixListModel.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/2/3.
//

import Foundation
import SwiftyCollectionViewFlowLayout


public class MixListSectionModel {
    public let sectionType: SwiftyCollectionViewSectionType
    public let models: [MixListModel]
    
    public init(sectionType: SwiftyCollectionViewSectionType, models: [MixListModel]) {
        self.sectionType = sectionType
        self.models = models
    }
}

public class MixListModel {
    public let width: CGFloat
    public let height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
}
