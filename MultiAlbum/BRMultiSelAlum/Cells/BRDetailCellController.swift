//
//  BRDetailCellController.swift
//  MultiAlbum
//
//  Created by Shine on 2018/1/10.
//

import UIKit

class BRDetailCellController: UICollectionViewCell {
    
    @IBOutlet weak var VImageView: BRImageDetailView!
    @IBOutlet weak var HImageView: BRImageDetailView!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var selectView: UIView!
    
    @IBOutlet weak var selectRight: NSLayoutConstraint!
    @IBOutlet weak var selectUp: NSLayoutConstraint!
    @IBOutlet weak var selectBtn: UIButton!
  
    var checkDict : [String:String]?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


