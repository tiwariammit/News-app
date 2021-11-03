//
//  GlobalMethods.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation
import UIKit
import SDWebImage



typealias completionOfImageDownload = ((UIImage)->Void)?
//MARK:-SD Web image
extension UIImageView{
    
    func setURLImage( _ imageURL : String?, andPlaceHolderImage placeHolder : UIImage?, onCompletionsOfImageDownloaded: completionOfImageDownload = nil){
        
        let url = URL(string: imageURL ?? "")
        
        self.sd_setImage(with: url, placeholderImage: placeHolder, options: .scaleDownLargeImages) { (image, error, cachetype, url) in
            
            if let img = image{
                onCompletionsOfImageDownloaded?(img)
            }
        }
    }
    
    func maskWith(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
}


