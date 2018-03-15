//
//  BRDetailViewController.swift
//  MultiAlbum
//
//  Created by Shine on 2018/1/9.
//

import UIKit
import Photos

let ImageHeight: CGFloat = 200.0
let OffsetSpeed: CGFloat = 25.0
class BRDetailViewController: BRCustomCollection {
    
    @IBOutlet weak var totalPicConfirm: UIBarButtonItem!
    
    @IBAction func selectPicAction(_ sender: UIBarButtonItem)
    {
        self.delegate?.didSelectConfirmPic(picAry: [])
    }
    var delegate : selectedPicAction?
    
    var Album : PHAssetCollection?
    var eachPhoto:PHFetchResult<PHAsset>?
    var selectIdx :IndexPath?
    var albumTitle : String?
    var selectedImg : UIImage?
    var isScaleMode : Bool = false
    let dateFormatter = DateFormatter()
    var selectedIdx : [String: Any] = [:]
    
    let smallPicRightCons : CGFloat = 19.0
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        let layout :UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width:  150 , height:  150)
        layout.scrollDirection = .horizontal
        
        useLayoutToLayoutNavigationTransitions = true
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()        
        title = self.albumTitle
        
        
        collectionView?.register(  UINib.init(nibName: "BRDetailCellController", bundle:    Bundle(for: type(of: self))), forCellWithReuseIdentifier: "BRDetailCellController")
        collectionView?.isPagingEnabled = false
        let fetchoptions = PHFetchOptions()
        fetchoptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        fetchoptions.predicate = NSPredicate(format: "mediaType = %d",  PHAssetMediaType.image.rawValue)
        
        self.eachPhoto = PHAsset.fetchAssets(in: self.Album!, options: fetchoptions)
        
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let dataAlbum : PHAssetCollection = Album
        {
            let fetchoptions = PHFetchOptions()
            fetchoptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            fetchoptions.predicate = NSPredicate(format: "mediaType = %d",  PHAssetMediaType.image.rawValue)
            
            let eachPhoto:PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: dataAlbum, options: fetchoptions)
            return eachPhoto.count
        }
        else
        {
            return 0
        }
        
    }
    
    // MARK: 註冊按鈕事件
    @objc func pressBtn(_ sender : UIButton!)
    {
        
        let cell = collectionView?.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as!BRDetailCellController
        
        if selectedIdx[String(sender.tag)] != nil
        {
            let perPhoto = self.eachPhoto![sender.tag]
            if( perPhoto.pixelWidth >  perPhoto.pixelHeight){
                cell.HImageView.imgCoverView.backgroundColor = UIColor.clear
                cell.HImageView.layer.borderWidth = 0
                
            }
            else
            {
                cell.VImageView.imgCoverView.backgroundColor = UIColor.clear
                cell.VImageView.layer.borderWidth = 0
            }
            selectedIdx.removeValue(forKey: String(sender.tag))
            
        }
        else
        {
            let perPhoto = self.eachPhoto![sender.tag]
            if( perPhoto.pixelWidth >  perPhoto.pixelHeight){
                cell.HImageView.imgCoverView.backgroundColor = UIColor.black
                cell.HImageView.imgCoverView.alpha = 0.4
                cell.HImageView.layer.borderWidth = 2
                cell.HImageView.layer.borderColor = UIColor.green.cgColor
            }
            else
            {
                cell.VImageView.imgCoverView.backgroundColor = UIColor.black
                cell.VImageView.imgCoverView.alpha = 0.4
                cell.VImageView.layer.borderWidth = 2
                cell.VImageView.layer.borderColor = UIColor.green.cgColor
                
            }
            selectedIdx[String(sender.tag)] = "Y"
        }
    }
    
    
    
    @objc func tapScrollViewAction(_ sender : UITapGestureRecognizer)
    {
        
        
        let tagNun : Int = (sender.view?.tag)!
        
        let cell = collectionView?.cellForItem(at: IndexPath(row: tagNun, section: 0)) as!BRDetailCellController
        
        if selectedIdx[String(tagNun)] != nil
        {
            let perPhoto = self.eachPhoto![tagNun]
            if( perPhoto.pixelWidth >  perPhoto.pixelHeight){
                cell.HImageView.imgCoverView.backgroundColor = UIColor.clear
                cell.HImageView.layer.borderWidth = 0
                
            }
            else
            {
                cell.VImageView.imgCoverView.backgroundColor = UIColor.clear
                cell.VImageView.layer.borderWidth = 0
            }
            selectedIdx.removeValue(forKey: String(tagNun))
            cell.selectBtn.setTitle("", for: .normal)
        }
        else
        {
            let perPhoto = self.eachPhoto![tagNun]
            if( perPhoto.pixelWidth >  perPhoto.pixelHeight){
                cell.HImageView.imgCoverView.backgroundColor = UIColor.black
                cell.HImageView.imgCoverView.alpha = 0.4
                cell.HImageView.layer.borderWidth = 2
                cell.HImageView.layer.borderColor = UIColor.green.cgColor
            }
            else
            {
                cell.VImageView.imgCoverView.backgroundColor = UIColor.black
                cell.VImageView.imgCoverView.alpha = 0.4
                cell.VImageView.layer.borderWidth = 2
                cell.VImageView.layer.borderColor = UIColor.green.cgColor
                
            }
            cell.selectBtn.setTitle("●", for: .normal)
            selectedIdx[String(tagNun)] = "Y"
        }
        
        self.totalPicConfirm.title = String(format:"確定選擇(%d)",selectedIdx.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BRDetailCellController", for: indexPath) as! BRDetailCellController
        
        
        cell.VImageView.showImg.image = nil
        cell.HImageView.showImg.image = nil
        
        var picSiz : CGSize
        let imgOption = PHImageRequestOptions()
        imgOption.isSynchronous = false
        imgOption.deliveryMode = .highQualityFormat
        
        for recognizer in cell.selectView.gestureRecognizers ?? [] {
            cell.selectView.removeGestureRecognizer(recognizer)
        }
        
        
        cell.selectView.tag = indexPath.row
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapScrollViewAction(_:)))
        cell.selectView.addGestureRecognizer(tap)
        
        let perPhoto = self.eachPhoto![indexPath.row]
        
        let directView : BRImageDetailView?
        
        
        var upCos : CGFloat = 0
        var rightCos : CGFloat = 0
        if( perPhoto.pixelWidth >  perPhoto.pixelHeight){
            
            upCos = smallPicRightCons
            rightCos  =  0
            directView = cell.HImageView
        }
        else
        {         
            
            upCos = 0
            rightCos  =  smallPicRightCons
            
            directView = cell.VImageView
        }
        
        if self.isScaleMode
        {
            picSiz = CGSize(width: 2048, height: 1536)
            
            imgOption.resizeMode = PHImageRequestOptionsResizeMode.exact
            
            cell.selectUp.constant =  0
            cell.selectRight.constant  =  0
            
        }
        else
        {
            picSiz = CGSize(width: 150, height: 150)
            
            cell.selectUp.constant = upCos
            cell.selectRight.constant  =  rightCos
        }
        
        //判別是否有被選到
        if selectedIdx[String(indexPath.row)] != nil
        {
            cell.selectBtn.setTitle("●", for: .normal)
            directView!.imgCoverView.backgroundColor = UIColor.black
            directView!.imgCoverView.alpha = 0.4
            directView!.layer.borderWidth = 2
            directView!.layer.borderColor = UIColor.green.cgColor
        }
        else
        {
            cell.selectBtn.setTitle("", for: .normal)
            directView!.imgCoverView.backgroundColor = UIColor.clear
            directView!.layer.borderWidth = 0
        }
        
        //Loading Picture
        PHImageManager.default().requestImage(for: perPhoto, targetSize:                picSiz, contentMode: .aspectFit, options: imgOption)
        { (result, info) -> Void in
            
            
            
            if let image = result
            {
                
                if( image.size.width < image.size.height) //直的
                {
                    cell.HImageView.isHidden = true
                    cell.VImageView.isHidden = false
                    cell.VImageView.showImg.image = image
                    
                }
                else
                {
                    cell.VImageView.isHidden = true
                    cell.HImageView.isHidden = false
                    cell.HImageView.showImg.image = image
                    
                }
            }
        }
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectIdx = indexPath
        self.isScaleMode = true
        
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.5
        //animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = 0.8
        animation.toValue = 1.0
        
        
        self.navigationController?.view.layer.add(transition, forKey: nil)
        
        
        let cell : BRDetailCellController = collectionView.cellForItem(at: indexPath) as! BRDetailCellController
        
        let perPhoto = self.eachPhoto![indexPath.row]
        
        let imgOption = PHImageRequestOptions()
        imgOption.resizeMode = PHImageRequestOptionsResizeMode.exact
        imgOption.isSynchronous = false
        imgOption.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImage(for: perPhoto, targetSize:                CGSize(width: 2048, height: 1536), contentMode: .aspectFit, options: imgOption)
        { (result, info) -> Void in
            
            if let image = result
            {
                cell.selectUp.constant =  0
                cell.selectRight.constant  =  0
                if( image.size.width < image.size.height) //直的
                {
                    cell.VImageView.showImg.image = image
                }
                else
                {
                    cell.HImageView.showImg.image = image
                }
            }
        }
        
        self.performSegue(withIdentifier: "toScale", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        switch segue.identifier {
        case .some("toScale"):
            let picScale : BRPicSclaeViewController = segue.destination as! BRPicSclaeViewController
            picScale.scalePhotos = self.eachPhoto
            picScale.selectIdx = self.selectIdx
            picScale.albumTitle = self.albumTitle
        default:
            break
        }
        
    }
}

extension BRDetailViewController: UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
}

