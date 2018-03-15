//
//  BRMultiAlbumSet.swift
//  MultiAlbum
//
//  Created by Shine on 2018/3/12.
//

import Foundation
import UIKit
import Photos
public class BRMultiAlbumSet: NSObject {
    
    public func getAlbumController() -> UINavigationController
    {
        let board : UIStoryboard = UIStoryboard(name: "BRMultiSelAlum", bundle:  Bundle(for: type(of: self)))
        let nvaVc :BRInitNaviController =  board.instantiateViewController(withIdentifier: "BRMultiSelAlumNav") as! BRInitNaviController
        return nvaVc
    }
    
    public override init() {
       
    }    
  
}

