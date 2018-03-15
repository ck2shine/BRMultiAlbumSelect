//
//  BRPicScaleLayout.swift
//  MultiAlbum
//
//  Created by i9400503 on 2018/1/19.
//

import UIKit

class BRPicScaleLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        
        self.itemSize = CGSize(width: 1024, height: 704)
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
       
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func prepare() {
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
