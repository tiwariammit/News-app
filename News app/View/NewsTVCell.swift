//
//  NewsTVCell.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation
import UIKit

class NewsTVCell: UITableViewCell {
    
    // initiallize news tile, description and image
    public let lblNewsTitle : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    public let lblNewsDescription : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public let ivNews : UIImageView = {
        let imgView = UIImageView(image: (UIImage(named: "imagePlaceholder")))
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(lblNewsTitle)
        addSubview(lblNewsDescription)
        addSubview(ivNews)
        
        let imagewidth = self.frame.width * 0.3
        
        ivNews.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 5, paddingRight: 10, width: imagewidth, height: imagewidth, enableInsets: false)
        
        lblNewsTitle.anchor(top: topAnchor, left: ivNews.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        lblNewsDescription.anchor(top: lblNewsTitle.bottomAnchor, left: ivNews.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
