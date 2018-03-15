//
//  BRPicSclaeViewController.swift
//  MultiAlbum
//
//  Created by Shine on 2018/1/18.
//

import UIKit
import Photos
class BRPicSclaeViewController: BRCustomCollection {
    
    var selectIdx : IndexPath?
    var albumTitle : String?
    var scalePhotos:PHFetchResult<PHAsset>?
    
    init() {
        
        super.init(collectionViewLayout: BRPicScaleLayout())
       
        
        //useLayoutToLayoutNavigationTransitions = true
    }
  

    /*
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        guard let flowLayout = self.collectionView?.collectionViewLayout as? BRPicScaleLayout else {
            return
        }
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            //here you can do the logic for the cell size if phone is in landscape
            print("land")
        } else {
             print("prot")
            //logic if not landscape
        }
        
        flowLayout.invalidateLayout()
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        
      
       
        
         super.init(collectionViewLayout: BRPicScaleLayout())
      
        useLayoutToLayoutNavigationTransitions = true
        
    }
    
    @IBOutlet var ScaleCol: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.changeTitle(picAsset: self.scalePhotos![(selectIdx?.row)!])
        
          self.navigationController?.navigationBar.topItem?.backBarButtonItem?.title = self.albumTitle
        collectionView?.register(  UINib.init(nibName: "BRSclaeCellController", bundle:    Bundle(for: type(of: self))), forCellWithReuseIdentifier: "BRSclaeCellController")
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return scalePhotos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BRSclaeCellController", for: indexPath) as! BRSclaeCellController
        
        let imgOption = PHImageRequestOptions()
        //imgOption.resizeMode = PHImageRequestOptionsResizeMode.exact
        imgOption.isSynchronous = false
        imgOption.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImage(for: self.scalePhotos![indexPath.row], targetSize:                PHImageManagerMaximumSize, contentMode: .aspectFit, options: imgOption)
        { (result, info) -> Void in
            
            if let image = result
            {
                
                cell.ScaleImg.image = image
               
            }
        }
        
        
        return cell
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        let index : Int = Int((self.collectionView?.contentOffset.x)!) /  Int((self.collectionView?.frame.size.width)!)
       
        let picAsset : PHAsset = scalePhotos![index]
        
        
        self.changeTitle(picAsset: picAsset)
    }
    
     override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = self.collectionView else {return}
        guard let visibleCells = collectionView.visibleCells as? [BRDetailCellController] else {return}
       
            for parallaxCell in visibleCells {
                let minusX  = (self.collectionView?.contentOffset.x)! - parallaxCell.frame.origin.x
                
                let imageOffsetX = (-minusX) * 0.4;
               
                parallaxCell.scrView.contentOffset = CGPoint(x: imageOffsetX, y: 0)
                
            }
        
    }
    
    func changeTitle( picAsset : PHAsset)
    {
        
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.month,.day,.hour, .minute,.second,], from: picAsset.creationDate!)
        let hour : Int = comp.hour!
        
        let noonNM =  (hour>12 ? "下午" : "上午")
        
        let fullDateNM =  String(format: "%d月%d日 %@ %d:%d", comp.month!, comp.day!,noonNM,comp.hour!,comp.minute!)
        
        
        self.title = fullDateNM
    }
    
}

extension BRPicSclaeViewController: UICollectionViewDelegateFlowLayout
{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
}
