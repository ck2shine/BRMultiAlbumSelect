//
//  BRSampleViewController.swift
//  MultiAlbum
//
//  Created by i9400503 on 2018/3/15.
//

import UIKit

class BRSampleCellController : UICollectionViewCell
{
    @IBOutlet weak var sImg: UIImageView!
    
}

class BRSampleViewController: UIViewController {
    var showImgAry : [UIImage] = []
    @IBOutlet weak var photosCollection: UICollectionView!
    @IBAction func selectAction(_ sender: Any) {
        let vc : BRMultiAlbumSet = BRMultiAlbumSet()
        let conVC : BRInitNaviController =  vc.getAlbumController() as! BRInitNaviController
        conVC.delegatePic = self       
 
        self.present(conVC, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BRSampleViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showImgAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BRSampleCell", for: indexPath) as! BRSampleCellController
        
        cell.sImg.image = showImgAry[indexPath.row]
        
        return cell
    }
    
    
}

extension BRSampleViewController : selectedPicAction
{
    func didSelectConfirmPic(picAry: Array<UIImage>) {
        showImgAry += picAry
        self.photosCollection.reloadData()
    }
}
