//
//  LoadingView.swift
//  DearJini
//
//  Created by Amrit on 5/9/19.
//  Copyright © 2019 tiwariammit@gmail.com. All rights reserved.
//

import Foundation
import UIKit


class LoadingView: UIView{
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    init(){
        super.init(frame: CGRect.zero)
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    public func remove(){
        self.activityIndicator.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    public func set(withLoadingView ldView: UIView, withBackgroundColor bg: UIColor, withLoadingIndicatorColor indicatorColor : UIColor){
        
        self.remove()
        let size : CGFloat = 80
        self.translatesAutoresizingMaskIntoConstraints = false
        ldView.addSubview(self)
        
        self.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.centerXAnchor.constraint(equalTo: ldView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: ldView.centerYAnchor).isActive = true
        
        self.backgroundColor = bg
        self.isUserInteractionEnabled = false
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.activityIndicator.color = indicatorColor
        
        self.activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
