//
//  HomeCollectionViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 18/10/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit
import Alamofire
class HomeCollectionViewController: UIViewController {

    @IBOutlet weak var placeCollectView: UICollectionView!
    
    let spacing = CGFloat(0.0);
    private var selectedTab = 0;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        WebAPIHandler.shared.getAllLandmarks(){ response in
            switch response.result{
            case .failure(let error):
                print(error.localizedDescription)
                UIFuncs.popUp(title: "Error", info: "Loading landmarks data failed, \(String(data: response.data!, encoding: String.Encoding.utf8)!)", type: UIFuncs.BlockPopType.warning , sender: self, callback: {})
            case .success(let _):
                self.placeCollectView.reloadData()
                
            }
        }
        
        WebAPIHandler.shared.getAllStreetView(){ response in
            switch response.result{
            case .failure(let error):
                print(error.localizedDescription)
                UIFuncs.popUp(title: "Error", info: "Loading street view data failed, \(String(data: response.data!, encoding: String.Encoding.utf8)!)", type: UIFuncs.BlockPopType.warning , sender: self, callback: {})
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
        if segue.identifier == "showLandmarkDetail"{
            let cell = sender as! HomeCollectionLandmarkViewCell
            let target = segue.destination as! HomeLandmarkDetailViewController
            target.predefinedCellData = cell.landMark
            target.index = cell.index
        }else if segue.identifier == "showStreetViewDetail"{
            let cell = sender as! HomeCollectionStreetViewCell
            let target = segue.destination as! HomeStreetViewDetailViewController
            target.streetView = cell.streetView
//            target.index = cell.index
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
    @IBAction func switchTab(_ sender: UISegmentedControl) {
        self.selectedTab = sender.selectedSegmentIndex
        self.placeCollectView.reloadData()
    }
    
}

extension HomeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.selectedTab == 0{
            return WebAPIHandler.shared.allLandmarks.count
        }
        return WebAPIHandler.shared.allStreetView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            if self.selectedTab == 0{
                if let cell = placeCollectView.dequeueReusableCell(withReuseIdentifier: "placeCell", for: indexPath) as? HomeCollectionLandmarkViewCell{
                    cell.landMark = WebAPIHandler.shared.allLandmarks[indexPath.row]
                    cell.imageView.image = UIImage(named: "\(indexPath.row + 1)")
                    cell.labelView.text = WebAPIHandler.shared.allLandmarks[indexPath.row].landmarkName
                    cell.index = indexPath.row
                    cell.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                    cell.layer.borderWidth = CGFloat(1)
                    return cell
                }
              
            }else{
                 if let cell = placeCollectView.dequeueReusableCell(withReuseIdentifier: "streetViewCell", for: indexPath) as? HomeCollectionStreetViewCell{
                        let streetView = WebAPIHandler.shared.allStreetView[indexPath.row]
                        cell.imageView.image = UIImage(named: "loading")
                        Alamofire.request( streetView.imageURL!).responseImage { response in
                            if let image = response.result.value {
                                cell.imageView.image = image
                            }
                        }
                        cell.labelView.text = streetView.streetViewName
                        cell.index = indexPath.row
                        cell.streetView = streetView
                        cell.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                        cell.layer.borderWidth = CGFloat(1)
                        return cell
                }
               
            }
            
        return UICollectionViewCell()
    }
        
    
    
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.selectedTab == 0{
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
        }else{
            if let collection = self.placeCollectView{
                let width = (collection.bounds.width - spacing) / 2
                let height =  (collection.bounds.height - spacing * 2 ) / 3
                return CGSize(width: width, height: height)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
       
    }
    
    
    
}
