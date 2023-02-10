//
//  CollectionViewUpdate.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/10.
//

import Foundation

internal enum CollectionViewUpdate<SectionModel, ItemModel> {
    
    case sectionReload(sectionIndex: Int, newSection: SectionModel)
    case itemReload(itemIndexPath: IndexPath, newItem: ItemModel)
    
    case sectionDelete(sectionIndex: Int)
    case itemDelete(itemIndexPath: IndexPath)
    
    case sectionInsert(sectionIndex: Int, newSection: SectionModel)
    case itemInsert(itemIndexPath: IndexPath, newItem: ItemModel)
    
    case sectionMove(initialSectionIndex: Int, finalSectionIndex: Int)
    case itemMove(initialItemIndexPath: IndexPath, finalItemIndexPath: IndexPath)
    
}
