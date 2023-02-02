//
//  SwiftyCollectionViewFlowLayout+TagList.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/1.
//

import Foundation
import UIKit


extension SwiftyCollectionViewFlowLayout {
    internal func _layoutTagListAttributesForItem(at section: Int) {
        guard let sectionModel = sectionModels[section] else { return }
        
        var direction: SwiftyCollectionViewDirection = .left
        switch sectionModel.sectionType {
            case .tagList(let _direction, _):
                direction = _direction
            default:
                return
        }
        
        if scrollDirection == .vertical {
            verticalLayout(sectionModel: sectionModel, direction: direction)
        } else if scrollDirection == .horizontal {
            horizontalLayout(sectionModel: sectionModel, direction: direction)
        }
    }
}

extension SwiftyCollectionViewFlowLayout {
    private func verticalLayout(sectionModel: BaseSectionModel, direction: SwiftyCollectionViewDirection) {
        guard let collectionView = collectionView else { return }
        
        var preAttr: UICollectionViewLayoutAttributes?
        var x: CGFloat = .zero
        var y: CGFloat = .zero
        var subAttributes: [UICollectionViewLayoutAttributes] = []
        var groupAttributes: [[UICollectionViewLayoutAttributes]] = []
        
        let containerWidth: CGFloat = collectionView.bounds.width - sectionModel.sectionInset.left - sectionModel.sectionInset.right
        
        switch direction {
            case .left:
                // left
                for attr in sectionModel.itemLayoutAttributes {
                    if preAttr != nil {
                        if (x + sectionModel.interitemSpacing + attr.frame.width).isLessThanOrEqualTo(collectionView.bounds.width - sectionModel.sectionInset.right) {
                            // no new line
                            attr.frame = CGRect(x: x + sectionModel.interitemSpacing,
                                                y: preAttr!.frame.origin.y,
                                                width: attr.frame.width,
                                                height: attr.frame.height)
                            x += (sectionModel.interitemSpacing + attr.frame.width)
                            if y.isLess(than: attr.frame.maxY) {
                                y = attr.frame.maxY
                            }
                            subAttributes.append(attr)
                        } else {
                            // new line
                            y += sectionModel.lineSpacing
                            x = sectionModel.sectionInset.left
                            
                            if !subAttributes.isEmpty {
                                groupAttributes.append(subAttributes)
                            }
                            subAttributes.removeAll()
                            
                            let w = min(attr.frame.width, containerWidth)
                            attr.frame = CGRect(x: x,
                                                y: y,
                                                width: w,
                                                height: attr.frame.height)
                            x += attr.frame.width
                            y += attr.frame.height
                            subAttributes.append(attr)
                        }
                    } else {
                        // first
                        x = sectionModel.sectionInset.left
                        y = .zero
                        
                        let w = min(attr.frame.width, containerWidth)
                        attr.frame = CGRect(x: x,
                                            y: y,
                                            width: w,
                                            height: attr.frame.height)
                        x += attr.frame.width
                        y = attr.frame.height
                        subAttributes.append(attr)
                    }
                    preAttr = attr
                }
                if !subAttributes.isEmpty {
                    groupAttributes.append(subAttributes)
                }
                subAttributes.removeAll()
            case .right:
                // right
                for attr in sectionModel.itemLayoutAttributes {
                    if preAttr != nil {
                        if !(x - sectionModel.interitemSpacing - attr.frame.width).isLess(than: sectionModel.sectionInset.left) {
                            // no new line
                            attr.frame = CGRect(x: x - sectionModel.interitemSpacing - attr.frame.width,
                                                y: preAttr!.frame.origin.y,
                                                width: attr.frame.width,
                                                height: attr.frame.height)
                            x -= (sectionModel.interitemSpacing + attr.frame.width)
                            if y.isLess(than: attr.frame.maxY) {
                                y = attr.frame.maxY
                            }
                            subAttributes.append(attr)
                        } else {
                            // new line
                            if !subAttributes.isEmpty {
                                groupAttributes.append(subAttributes)
                            }
                            subAttributes.removeAll()
                            
                            let w = min(attr.frame.width, containerWidth)
                            
                            y += sectionModel.lineSpacing
                            x = collectionView.bounds.width - sectionModel.sectionInset.right - w
                            
                            attr.frame = CGRect(x: x,
                                                y: y,
                                                width: w,
                                                height: attr.frame.height)
                            y += attr.frame.height
                            subAttributes.append(attr)
                        }
                    } else {
                        // first
                        let w = min(attr.frame.width, containerWidth)
                        
                        x = collectionView.bounds.width - sectionModel.sectionInset.right - w
                        y = .zero
                        
                        attr.frame = CGRect(x: x,
                                            y: y,
                                            width: w,
                                            height: attr.frame.height)
                        y = attr.frame.height
                        subAttributes.append(attr)
                    }
                    preAttr = attr
                }
                if !subAttributes.isEmpty {
                    groupAttributes.append(subAttributes)
                }
                subAttributes.removeAll()
        }
        layoutAlignment(sectionType: sectionModel.sectionType, groupAttributes: groupAttributes)
    }
    
    private func horizontalLayout(sectionModel: BaseSectionModel, direction: SwiftyCollectionViewDirection) {
        guard let collectionView = collectionView else { return }
        
        var preAttr: UICollectionViewLayoutAttributes?
        var x: CGFloat = .zero
        var y: CGFloat = .zero
        var subAttributes: [UICollectionViewLayoutAttributes] = []
        var groupAttributes: [[UICollectionViewLayoutAttributes]] = []
        
        let containerHeight: CGFloat = collectionView.bounds.height - sectionModel.sectionInset.top - sectionModel.sectionInset.bottom
        
        switch direction {
            case .left:
                for attr in sectionModel.itemLayoutAttributes {
                    if preAttr != nil {
                        if (y + sectionModel.interitemSpacing + attr.frame.height).isLessThanOrEqualTo(collectionView.bounds.height - sectionModel.sectionInset.bottom) {
                            // no new line
                            attr.frame = CGRect(x: preAttr!.frame.origin.x,
                                                y: y + sectionModel.interitemSpacing,
                                                width: attr.frame.width,
                                                height: attr.frame.height)
                            y += (sectionModel.interitemSpacing + attr.frame.height)
                            if x.isLess(than: attr.frame.maxX) {
                                x = attr.frame.maxX
                            }
                            subAttributes.append(attr)
                        } else {
                            // new line
                            y = sectionModel.sectionInset.top
                            x += sectionModel.lineSpacing
                            
                            if !subAttributes.isEmpty {
                                groupAttributes.append(subAttributes)
                            }
                            subAttributes.removeAll()
                            
                            let h = min(attr.frame.height, containerHeight)
                            attr.frame = CGRect(x: x,
                                                y: y,
                                                width: attr.frame.width,
                                                height: h)
                            x += attr.frame.width
                            y += attr.frame.height
                            subAttributes.append(attr)
                        }
                    } else {
                        // first
                        x = .zero
                        y = sectionModel.sectionInset.top
                        
                        let h = min(attr.frame.height, containerHeight)
                        attr.frame = CGRect(x: x,
                                            y: y,
                                            width: attr.frame.width,
                                            height: h)
                        x = attr.frame.width
                        y += attr.frame.height
                        subAttributes.append(attr)
                    }
                    preAttr = attr
                }
                if !subAttributes.isEmpty {
                    groupAttributes.append(subAttributes)
                }
                subAttributes.removeAll()
            case .right:
                for attr in sectionModel.itemLayoutAttributes {
                    if preAttr != nil {
                        if !(y - sectionModel.interitemSpacing - attr.frame.height).isLess(than: sectionModel.sectionInset.top) {
                            // no new line
                            attr.frame = CGRect(x: preAttr!.frame.origin.x,
                                                y: y - sectionModel.interitemSpacing - attr.frame.height,
                                                width: attr.frame.width,
                                                height: attr.frame.height)
                            y -= (sectionModel.interitemSpacing + attr.frame.height)
                            if x.isLess(than: attr.frame.maxX) {
                                x = attr.frame.maxX
                            }
                            subAttributes.append(attr)
                        } else {
                            // new line
                            if !subAttributes.isEmpty {
                                groupAttributes.append(subAttributes)
                            }
                            subAttributes.removeAll()
                            
                            let h = min(attr.frame.height, containerHeight)
                            
                            y = collectionView.bounds.height - sectionModel.sectionInset.bottom - h
                            x += sectionModel.lineSpacing
                            
                            attr.frame = CGRect(x: x,
                                                y: y,
                                                width: attr.frame.width,
                                                height: h)
                            x += attr.frame.width
                            subAttributes.append(attr)
                        }
                    } else {
                        // first
                        let h = min(attr.frame.height, containerHeight)
                        
                        x = .zero
                        y = collectionView.bounds.height - sectionModel.sectionInset.bottom - h
                        
                        attr.frame = CGRect(x: x,
                                            y: y,
                                            width: attr.frame.width,
                                            height: h)
                        x = attr.frame.width
                        subAttributes.append(attr)
                    }
                    preAttr = attr
                }
                if !subAttributes.isEmpty {
                    groupAttributes.append(subAttributes)
                }
                subAttributes.removeAll()
        }
        layoutAlignment(sectionType: sectionModel.sectionType, groupAttributes: groupAttributes)
    }
}

extension SwiftyCollectionViewFlowLayout {
    private func layoutAlignment(sectionType: SwiftyCollectionViewSectionType, groupAttributes: [[UICollectionViewLayoutAttributes]]) {
        //
        if groupAttributes.isEmpty { return }
        //
        var alignment: SwiftyCollectionViewAlignment = .top
        switch sectionType {
            case .tagList(_, let _alignment):
                alignment = _alignment
            default:
                break
        }
        //
        switch alignment {
            case .top:
                // Default top
                break
            case .center:
                if scrollDirection == .vertical {
                    for subAttributes in groupAttributes {
                        if subAttributes.isEmpty { continue }
                        var maxAttr = subAttributes.first!
                        for attr in subAttributes {
                            if maxAttr.frame.height.isLess(than: attr.frame.height) {
                                maxAttr = attr
                            }
                        }
                        for attr in subAttributes {
                            var frame = attr.frame
                            frame.origin.y += (maxAttr.frame.height - attr.frame.height) / 2.0
                            attr.frame = frame
                        }
                    }
                } else if scrollDirection == .horizontal {
                    for subAttributes in groupAttributes {
                        if subAttributes.isEmpty { continue }
                        var maxAttr = subAttributes.first!
                        for attr in subAttributes {
                            if maxAttr.frame.width.isLess(than: attr.frame.width) {
                                maxAttr = attr
                            }
                        }
                        for attr in subAttributes {
                            var frame = attr.frame
                            frame.origin.x += (maxAttr.frame.width - attr.frame.width) / 2.0
                            attr.frame = frame
                        }
                    }
                }
            case .bottom:
                if scrollDirection == .vertical {
                    for subAttributes in groupAttributes {
                        if subAttributes.isEmpty { continue }
                        var maxAttr = subAttributes.first!
                        for attr in subAttributes {
                            if maxAttr.frame.height.isLess(than: attr.frame.height) {
                                maxAttr = attr
                            }
                        }
                        for attr in subAttributes {
                            var frame = attr.frame
                            frame.origin.y += (maxAttr.frame.height - attr.frame.height)
                            attr.frame = frame
                        }
                    }
                } else if scrollDirection == .horizontal {
                    for subAttributes in groupAttributes {
                        if subAttributes.isEmpty { continue }
                        var maxAttr = subAttributes.first!
                        for attr in subAttributes {
                            if maxAttr.frame.width.isLess(than: attr.frame.width) {
                                maxAttr = attr
                            }
                        }
                        for attr in subAttributes {
                            var frame = attr.frame
                            frame.origin.x += (maxAttr.frame.width - attr.frame.width)
                            attr.frame = frame
                        }
                    }
                }
        }
    }
}
