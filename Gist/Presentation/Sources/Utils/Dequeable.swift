import Foundation
import UIKit

public protocol Reusable {
    static var identifier: String { get }
}

public extension Reusable {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableViewHeaderFooterView: Reusable { }
extension UITableViewCell: Reusable { }
extension UICollectionReusableView: Reusable { }

@objc
public protocol Dequeable: AnyObject {}

extension UITableViewCell: Dequeable {}
extension UITableViewHeaderFooterView: Dequeable {}

public extension Dequeable where Self: UITableViewHeaderFooterView {
    static func dequeued(fromTableView tableView: UITableView, atIndexPath indexPath: IndexPath? = nil) -> Self? {
        let view: Self? = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? Self

        if view == .none {
            print("Could not dequeue footer/header view for identifier \(self.identifier)")
        }
        return view
    }
}

public extension Dequeable where Self: UITableViewCell {
    static func dequeued(fromTableView tableView: UITableView, atIndexPath indexPath: IndexPath? = nil) -> Self? {
        var cell: Self?
        if let path = indexPath {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: path) as? Self
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? Self
        }

        if cell == .none {
            print("Could not dequeue cell for identifier \(self.identifier)")
        }
        return cell
    }
}

public extension Dequeable where Self: UICollectionViewCell {
    static func dequeued(fromCollectionView collectionView: UICollectionView, for indexPath: IndexPath) -> Self? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Self
        if cell == .none {
            print("Could not dequeue cell for identifier \(identifier)")
        }
        return cell
    }
}

extension UICollectionReusableView: Dequeable {}
public extension Dequeable where Self: UICollectionReusableView {
    static func dequeued(ofKind kind: String, fromCollectionView collectionView: UICollectionView, for indexPath: IndexPath) -> Self? {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? Self
        if cell == .none {
            print("Could not dequeue cell for identifier \(identifier)")
        }
        return cell
    }
}
