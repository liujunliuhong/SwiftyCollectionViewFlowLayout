//
//  SwiftyCollectionViewLayoutSupplementaryVisibilityMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/13.
//

import Foundation
import UIKit

/// Represents the visibility mode for a header/footer.
public enum SwiftyCollectionViewLayoutSupplementaryVisibilityMode: Equatable {
    
    /// This visibility mode will cause the header/footer to not be visible in its respective section.
    case hidden
    
    /// This visibility mode will cause the header/footer to be displayed using the specified size mode in
    /// its respective section.
    case visible(sizeMode: SwiftyCollectionViewLayoutSizeMode)
}
