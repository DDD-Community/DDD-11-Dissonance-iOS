//
//  ReusableCell.swift
//  DesignSystem
//
//  Created by 이원빈 on 8/5/24.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import UIKit

public protocol ReusableView: AnyObject {
  static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
  static var defaultReuseIdentifier: String {
    return NSStringFromClass(self)
  }
}

extension UITableViewCell: ReusableView { }

extension UITableView {
  
  public func register<T: UITableViewCell>(_: T.Type) {
    register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
    }
    return cell
  }
}

//extension UICollectionViewCell: ReusableView { }
extension UICollectionReusableView: ReusableView { }

extension UICollectionView {
  
  public func register<T: UICollectionViewCell>(_: T.Type) {
    register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  public func register<T: UICollectionReusableView>(_ viewClass: T.Type, forSupplementaryViewOfKind elementKind: String) {
    register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
    }
    return cell
  }
  
  public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T {
    guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue reusableSupplementaryView: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
    }
    return view
  }
}
