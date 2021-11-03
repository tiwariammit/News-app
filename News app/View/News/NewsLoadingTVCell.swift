//
//  NewsLoadingTVCell.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation
import UIKit

class NewsLoadingTVCell: UITableViewCell {
    
    var activityIndicator: UIActivityIndicatorView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        

        self.activityIndicator.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.height / 2)
//        self.center
        
        self.addSubview(self.activityIndicator)
        self.activityIndicator.layoutSubviews()
        self.activityIndicator.layoutIfNeeded()
        
        self.activityIndicator.startAnimating()
        
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
