//
//  ViewControllerExtension.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation
import UIKit

extension UIViewController{
    
    public func presentErrorDialog(_ message : String){
        
        let views = self.view.window ?? self.view
        
        var style = ToastManager.shared.style
        style.backgroundColor = .toastError
        style.cornerRadius = 0
        
        views?.makeToast(message, position: .bottom, title: nil, image: nil, style: style, completion: nil)
    }

}



//MARK:-UIStoryBoard
extension UIStoryboard {
    
    enum Storyboard: String {
        case Main
      

        var filename: String {
            return rawValue
        }
    }
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    func instantiateViewController<T>() -> T where T: StoryboardInstantiable {
        guard let viewController = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier)")
        }
        
        return viewController
    }
    
}

protocol StoryboardInstantiable {
    
    static var storyboardIdentifier: String { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func create(of storyboard: UIStoryboard.Storyboard) -> Self {
        let sb = UIStoryboard(storyboard: storyboard)
        return sb.instantiateViewController()
    }
}

public protocol NibLoadable: class {
    /// The nib file to use to load a new instance of the View designed in a XIB
    static var nib: UINib { get }
}

// MARK: Default implementation
public extension NibLoadable {
    /// By default, use the nib which have the same name as the name of the class,
    /// and located in the bundle of that class
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

//MARK:- UICollectionView
extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: NibLoadable {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: Reusable>(elementKind: String, _: T.Type) where T: NibLoadable {
        register(T.nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: Reusable>(elementKind: String, _: T.Type) {
        register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T {
            return cell
        }
        else {
            fatalError("The dequeueReusableCell \(String(describing: T.self)) couldn't be loaded.")
        }
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(elementKind: String, for indexPath: IndexPath) -> T {
        if let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T {
            return view
        }
        else {
            fatalError("The dequeueReusableSupplementaryView \(String(describing: T.self)) couldn't be loaded.")
        }
    }
}




//MARK:- UITableView
extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadable {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type){
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: NibLoadable {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T {
            return cell
        }
        else {
            fatalError("The dequeueReusableCell \(String(describing: T.self)) couldn't be loaded.")
        }
    }
    
    func dequeueReusableView<T: UITableViewHeaderFooterView>() -> T {
        if let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T {
            return view
        }
        else {
            fatalError("The dequeueReusableView \(String(describing: T.self)) couldn't be loaded.")
        }
    }
}


protocol Reusable: class {
    
    static var reuseIdentifier: String { get }
   
}

extension Reusable  {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//MARK:-UIViewController
extension UIViewController: StoryboardInstantiable, AppImagePlaceholder { }


//MARK:- UICollectionViewCell
//extension UICollectionViewCell { }


extension UICollectionReusableView: Reusable, AppImagePlaceholder { }


//MARK:- UITableViewCell
extension UITableViewCell: Reusable, AppImagePlaceholder { }

//MARK:- UITableViewCell
extension UITableViewHeaderFooterView: Reusable { }

protocol AppImagePlaceholder {
    
    func placeholderSmallImage() -> UIImage?
    func placeholderBigImage() -> UIImage?
    func placeholderUserImage() -> UIImage?
    func placeholderRectangularImage() -> UIImage?
}


extension AppImagePlaceholder{
    
    func placeholderSmallImage() -> UIImage?{
        return UIImage(named: "imagePlaceholder")
    }
    
    func placeholderBigImage() -> UIImage?{
        return UIImage(named: "imagePlaceholder")
    }
    
    func placeholderUserImage() -> UIImage?{
        return UIImage(named: "imagePlaceholder")
    }
    
    func placeholderRectangularImage() -> UIImage?{
        return UIImage(named: "imagePlaceholder")
    }
}
