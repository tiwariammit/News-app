//
//  ErrorView.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation
import UIKit

class ErrorView : UIView{
    
    // initiallize news tile, button
    public let lblErrorTitle : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    public let btnRetry : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        let space = "   "
        btn.setTitle(space+"Try Again"+space, for: .normal)
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.lblErrorTitle)
        self.addSubview(self.btnRetry)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let y = self.frame.height/4
        
        self.lblErrorTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: y, paddingLeft: 30, paddingBottom: 5, paddingRight: 30, width: 0, height: 0, enableInsets: false)
        
        let x = self.bounds.width/2 - self.btnRetry.frame.width/2
    
        self.btnRetry.frame = CGRect(x: x, y: 50, width: self.btnRetry.frame.width, height: 50)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
