# SwiftyCollectionViewFlowLayout

A collection view layout capable of laying out views in vertically and horizontal scrolling grids and lists.

## Introduction

`SwiftyCollectionViewFlowLayout` is a `UICollectionViewLayout` subclass for laying out vertically and horizontal scrolling grids and lists of items. Compared to `UICollectionViewFlowLayout`, `SwiftyCollectionViewFlowLayout` supports many additional features:

- Support `Vertical` and `Horizontal` scroll direction.
- Support water-flow and grid list.
- Hiding or showing headers and footers on a per-section basis.
- Self-sizing headers and footers.
- Headers and footers offset.
- Headers and footer direction.
- Pinned (sticky) headers and footers on a per-section basis.
- Section background that can be hidden/visible on a per-section basis.
- Section background inset.
- Per-item self-sizing preferences (self-size and statically-size items anywhere in your collection view).
- Item width/height based on a fraction of the total available width/height.
- Item width/height ratio.

## Preview

## Getting Start

### Requirements

- Deployment target iOS 11.0+
- Swift 5+
- Xcode 14+

### Installation

#### CocoaPods

```ruby
pod 'SwiftyCollectionViewFlowLayout'
```

### Usage

Once you've integrated the `SwiftyCollectionViewFlowLayout` into your project, using it with a collection view is easy.

#### Setting up cells and headers

`SwiftyCollectionViewFlowLayout` requires its own UICollectionViewCell and UICollectionReusableView subclasses:

- `SwiftyCollectionViewCell`
- `SwiftyCollectionReusableView`

These two types enable cells and supplementary views to self-size correctly when using `SwiftyCollectionViewFlowLayout` .

#### Importing SwiftyCollectionViewFlowLayout

At the top of the file where you'd like to use `SwiftyCollectionViewFlowLayout`, import `SwiftyCollectionViewFlowLayout`.

```swift
import SwiftyCollectionViewFlowLayout
```

#### Setting up the collection view

Create your UICollectionView instance, passing in a `SwiftyCollectionViewFlowLayout` instance for the layout parameter.

```swift
let layout = SwiftyCollectionViewFlowLayout()
layout.scrollDirection = .vertical

let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
collectionView.dataSource = self
collectionView.delegate = self

view.addSubview(collectionView)
// Use SnapKit
collectionView.snp.makeConstraints { make in
    make.edges.equalToSuperview()
}
```

#### Registering cells and supplementary views

```swift
// Cell
collectionView.register(MyCell.classForCoder(), forCellWithReuseIdentifier: "MyCellReuseIdentifier")

// Header
collectionView.register(MyHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyHeaderReuseIdentifier")

//Footer
collectionView.register(MyFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyFooterReuseIdentifier")
```

#### Section Background view

`SwiftyCollectionViewFlowLayout` support section background view. (very like decoration view)

```swift
collectionView.register(DecorationView.classForCoder(), forSupplementaryViewOfKind: SwiftyCollectionViewFlowLayout.SectionBackgroundElementKind, withReuseIdentifier: NSStringFromClass(DecorationView.classForCoder()))
```

section background view do not self-size. so, the section background view can subclasses from `UICollectionReusableView`

#### Configuring the delegate






