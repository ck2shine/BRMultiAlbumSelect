//
//  BRMultiSelAlumViewController.swift
//  MultiAlbum
//
//  Created by Shine on 2017/12/29.
//

import UIKit
import Photos


class BRMultiSelAlumViewController: BRCustomCollection {
    
    @IBOutlet weak var albumCol: UICollectionView!
    
    var SelectAlbumKey : [String:String]?
    var filterAlbumAry:[PHAssetCollection] = []
    var sendAlbum : PHAssetCollection?
    var sendAlbumNM : String? = nil
    var delegate : selectedPicAction?
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(  UINib.init(nibName: "BRAlbumCellController", bundle:    Bundle(for: type(of: self))), forCellWithReuseIdentifier: "BRAlbumCellController")
        
        SelectAlbumKey = [
            "Camera Roll":"相機膠捲" ,
            "Favorites" : "我的最愛"
            , "Recently Added" : "最近新增" ,
              "Screenshots" :"螢幕快照" ]
        
        checkPhotoLibraryPermission()
        
        
    }
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(){status in
                
                switch status{
                case.authorized:
                    self.getAllAlbum()
                case.denied:
                    self.dismiss(animated: true, completion: nil)
                case.notDetermined:
                    self.dismiss(animated: true, completion: nil)
                default:
                    break
                }
            }
        case.restricted:
            self.dismiss(animated: true, completion: nil)
        case.denied:
            PHPhotoLibrary.requestAuthorization(){status in
                
                switch status{
                case.authorized:
                    self.getAllAlbum()
                case.denied:
                    self.dismiss(animated: true, completion: nil)
                case.notDetermined:
                    self.dismiss(animated: true, completion: nil)
                default:
                    break
                }
            }
        case.authorized:
            self.getAllAlbum()
        }
    }
    
    
    @IBAction func unwindToMainVc(_ sender : UIStoryboardSegue)
    {
        
        let vc : BRDetailViewController = sender.source as! BRDetailViewController
        
        var imgAry : [UIImage] = []
        
        let imgOption = PHImageRequestOptions()
        imgOption.resizeMode = PHImageRequestOptionsResizeMode.exact
        imgOption.isSynchronous = true
        imgOption.deliveryMode = .highQualityFormat
        
        for key in vc.selectedIdx.keys
        {
            let idx : Int = Int(key)!
            
            let perPhoto = vc.eachPhoto![idx]
            
            
            PHImageManager.default().requestImage(for: perPhoto, targetSize:                CGSize(width: 1024, height: 768), contentMode: .aspectFit, options: imgOption)
            { (result, info) -> Void in
                
                if let image = result
                {
                    imgAry.append(image)
                }
            }
        }
        
        self.delegate?.didSelectConfirmPic(picAry: imgAry)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAllAlbum()
    {
        PHPhotoLibrary.shared()
        
        let  albumAry : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.any, options: nil)
        
        albumAry.enumerateObjects(options: .concurrent, using: { (col, idx, stop) in
            let collection = col
            
            
            if ((self.SelectAlbumKey![collection.localizedTitle!]) != nil)
            {
                
                let fetchoptions = PHFetchOptions()
                fetchoptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                fetchoptions.predicate = NSPredicate(format: "mediaType = %d",  PHAssetMediaType.image.rawValue)
                
                let eachPhoto:PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: fetchoptions)
                
                if (eachPhoto.count > 0 || collection.localizedTitle == "Camera Roll")
                {
                    self.filterAlbumAry.append(collection)
                }
                
                
            }
        })
        
        self.filterAlbumAry.sort { (albumA, albumB) -> Bool in
            let titleA :String =  albumA.localizedTitle!
            let titleB :String =  albumB.localizedTitle!
            return titleA < titleB
        }
        
        let customAlbumAry : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchTopLevelUserCollections(with: nil) as! PHFetchResult<PHAssetCollection>
        
        customAlbumAry.enumerateObjects(options: .concurrent) { (col, idx, stop) in
            let collection = col
            self.filterAlbumAry.append(collection)
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
        
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : BRDetailViewController =  segue.destination as! BRDetailViewController
        vc.Album = self.sendAlbum
        vc.albumTitle = self.sendAlbumNM
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.sendAlbum = self.filterAlbumAry[indexPath.row]
        
        let cell =   collectionView.cellForItem(at: indexPath) as! BRAlbumCellController
        self.sendAlbumNM = cell.albumTitle.text!
       
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filterAlbumAry.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BRAlbumCellController", for: indexPath) as! BRAlbumCellController
        
        
        let eachAlbum : PHAssetCollection = self.filterAlbumAry[indexPath.row]
        
        if let albumChNM = self.SelectAlbumKey![eachAlbum.localizedTitle!]
        {
            cell.albumTitle.text = albumChNM
        }
        else
        {
            cell.albumTitle.text = eachAlbum.localizedTitle
        }
        
        let fetchoptions = PHFetchOptions()
        fetchoptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        fetchoptions.predicate = NSPredicate(format: "mediaType = %d",  PHAssetMediaType.image.rawValue)
        
        let eachPhoto:PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: eachAlbum, options: fetchoptions)
        
        cell.imgCountLb.text = String(eachPhoto.count)
        
        if(eachPhoto.count > 0){
            
            cell.albumImge.backgroundColor = UIColor.clear
            cell.albumImge.cornerRadius = 0
            cell.albumImge.alpha = 1
            let perPhoto = eachPhoto[0]
            
            let imgOption = PHImageRequestOptions()
            //imgOption.resizeMode = PHImageRequestOptionsResizeMode.exact
            imgOption.isSynchronous = false
            imgOption.deliveryMode = .highQualityFormat
            
            
            
            PHImageManager.default().requestImage(for: perPhoto, targetSize:                CGSize(width: 200, height: 200), contentMode: .aspectFit, options: imgOption)
            { (result, info) -> Void in
                
                if let image = result
                {
                    cell.albumImge.image = image
                }
                
            }
        }else{
            cell.albumImge.backgroundColor = UIColor.lightGray
            cell.albumImge.cornerRadius = 5
            cell.albumImge.alpha = 0.7
        }
        
        return cell
    }    
    
}

