//
//  BRImageDetailView.swift
//  MultiAlbum
//
//  Created by Shine on 2018/2/12.
//

import UIKit
@IBDesignable
class BRImageDetailView: UIView {
   
   
    @IBOutlet weak var showImg: UIImageView!

    @IBOutlet weak var imgCoverView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupAllUnit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.setupAllUnit()
    }
    
    
    func setupAllUnit()
    {
       
  
        
        guard let contentView :UIView = Bundle(for: type(of: self)).loadNibNamed("BRImageDetailView", owner: self, options: nil)?.first as? UIView
            else{
                return
        }
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
         contentView.frame = self.bounds
       
        self.addSubview(contentView)
    }
    

}
extension UIView {
        
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var coverborderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue > 0 ? newValue : 0
        }
    }
    
    @IBInspectable var coverBorderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}

