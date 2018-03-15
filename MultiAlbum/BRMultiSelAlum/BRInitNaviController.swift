//
//  BRInitNaviController.swift
//  MultiAlbum
//
//  Created by Shine on 2018/3/14.
//

import UIKit

public class BRInitNaviController: UINavigationController {

    
   public var delegatePic : selectedPicAction? {
        didSet {
           let vc : BRMultiSelAlumViewController = self.childViewControllers[0] as! BRMultiSelAlumViewController
            vc.delegate = delegatePic
        }
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
