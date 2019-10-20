//
//  HomeCollectionViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 18/10/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UIViewController {

    @IBOutlet weak var placeCollectView: UICollectionView!
    
    let spacing = CGFloat(10.0);
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        WebAPIHandler.shared.getAllLandmarks(){ response in
            switch response.result{
            case .failure(let error):
                print(error.localizedDescription)
                UIFuncs.popUp(title: "Error", info: "Login failed, \(String(data: response.data!, encoding: String.Encoding.utf8)!)", type: UIFuncs.BlockPopType.warning , sender: self, callback: {})
            case .success(let _):
                self.placeCollectView.reloadData()
                
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.placeCollectView.collectionViewLayout = layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let cell = sender as! HomeCollectionViewCell
            let target = segue.destination as! HomeDetailViewController
            target.predefinedCellData = cell.landMark
        
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WebAPIHandler.shared.allLandmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = placeCollectView.dequeueReusableCell(withReuseIdentifier: "placeCell", for: indexPath) as? HomeCollectionViewCell{
            cell.landMark = WebAPIHandler.shared.allLandmarks[indexPath.row]
            cell.imageView.image = UIImage(named: "\(indexPath.row + 1)")
            cell.labelView.text = WebAPIHandler.shared.allLandmarks[indexPath.row].landmarkName
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
//    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//
//        let columnCount: CGFloat = 3
//        let rowCount: CGFloat = 5
////        let cellWidth = UIScreen.main.bounds.size.width / columnCount
////        let cellHeight = UIScreen.main.bounds.size.height / rowCount
////        return CGSize(width: cellWidth, height: cellHeight)
//
//        let cellHeight = (collectionView.bounds.size.height - 60) / rowCount // 3 count of rows to show
//        let cellWidth = (collectionView.bounds.size.width - 40) / columnCount
//        return CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let rowCount: CGFloat = 5

        let totalRowSpacing = (numberOfItemsPerRow + 1) * spacing //Amount of total spacing in a row
        let totalHeighSpacing = (rowCount + 1) * spacing //Amount of total spacing in a row

        if let collection = self.placeCollectView{
            let width = (collection.bounds.width - totalRowSpacing)/numberOfItemsPerRow
            let height =  (collection.bounds.height - totalHeighSpacing)/rowCount
            return CGSize(width: width, height: height)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    
    
}
