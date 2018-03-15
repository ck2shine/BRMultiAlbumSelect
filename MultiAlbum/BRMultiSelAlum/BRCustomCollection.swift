//
//  BRCustomCollection.swift
//  MultiAlbum
//
//  Created by Shine on 2018/1/11.
//

import UIKit


extension BRCustomCollection : UINavigationControllerDelegate
{
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        guard let detailVC = viewController as? BRCustomCollection else { return }
        
        
        if viewController is BRPicSclaeViewController{
            let scaleVC : BRPicSclaeViewController = viewController as!BRPicSclaeViewController
            scaleVC.collectionView?.isPagingEnabled = true
            let cells =   scaleVC.collectionView?.visibleCells
            
            
            var refreshAry :Array<IndexPath> = []
            
            for cell in cells!
            {
                let index =  scaleVC.collectionView?.indexPath(for: cell)
                if(index?.row != scaleVC.selectIdx?.row){
                    refreshAry.append(index!)
                }
                
            }
            scaleVC.collectionView?.reloadItems(at:  refreshAry )
            
            
        }
        else if viewController is BRDetailViewController
        {
            let scaleVC : BRDetailViewController = viewController as!BRDetailViewController
            scaleVC.collectionView?.isPagingEnabled = false
            detailVC.collectionView?.delegate = detailVC
            detailVC.collectionView?.dataSource = detailVC
            scaleVC.isScaleMode = false
            
            let cells =   scaleVC.collectionView?.visibleCells
            
            
            var refreshAry :Array<IndexPath> = []
            
            for cell in cells!
            {
                let index =  scaleVC.collectionView?.indexPath(for: cell)
                refreshAry.append(index!)
            }
            scaleVC.collectionView?.reloadItems(at:  refreshAry )
            
        }
        else
        {
            detailVC.collectionView?.delegate = detailVC
            detailVC.collectionView?.dataSource = detailVC
        }
        
    }
    
    
}
class BRCustomCollection: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        
    }    
    
}
