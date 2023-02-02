//
//  TagListModel.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/1.
//

import Foundation
import UIKit
public final class TagListModel {
    public let title: String?
    
    public let font: UIFont = UIFont.systemFont(ofSize: 15)
    public let textColor = UIColor.white
    public let backgroundColor = UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 193.0/255.0, alpha: 1)
    
    public init(title: String?) {
        self.title = title
    }
}
