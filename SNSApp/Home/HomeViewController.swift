//
//  HomeViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 1/10/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var placeListTableView: UITableView!
//    let PredefinedCells: [Landmark] = []
//    [(title: String,description: String, smallImageUrl :String, largeImageUrl: String)] = [
//        ( title: "Arts Centre",
//          description: "Arts Centre description",
//         smallImageUrl: "https://freeaussiestock.com/free/Victoria/Melbourne/slides/arts_centre_sprire.jpg",
//         largeImageUrl:"https://freeaussiestock.com/free/Victoria/Melbourne/slides/arts_centre_sprire.jpg"
//            ),
//        ( title: "Brighton Bathing Boxes",
//          description: "Brighton Bathing Boxes description",
//          smallImageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Bathing_Boxes_Brighton_14_%288110486377%29.jpg/640px-Bathing_Boxes_Brighton_14_%288110486377%29.jpg",
//          largeImageUrl:"https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Bathing_Boxes_Brighton_14_%288110486377%29.jpg/640px-Bathing_Boxes_Brighton_14_%288110486377%29.jpg"
//        ),
//        ( title: "Chinatown",
//          description: "Chinatown description",
//          smallImageUrl: "https://cdn.pixabay.com/photo/2017/04/26/10/29/chinatown-2262230_960_720.jpg",
//          largeImageUrl:"https://cdn.pixabay.com/photo/2017/04/26/10/29/chinatown-2262230_960_720.jpg"
//        )
//    ]
//
    override func viewDidLoad() {
        super.viewDidLoad()

        WebAPIHandler.shared.getAllLandmarks(){ response in
            switch response.result{
            case .failure(let error):
                print(error.localizedDescription)
                UIFuncs.popUp(title: "Error", info: "Login failed, \(String(data: response.data!, encoding: String.Encoding.utf8)!)", type: UIFuncs.BlockPopType.warning , sender: self, callback: {})
            case .success(let value):
                self.placeListTableView.reloadData()
                
            }
        }
        // Do any additional setup after loading the view.
//        placeListTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "placeCell")
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let cell = sender as! HomeTableViewCell
            let target = segue.destination as! HomeDetailViewController
            target.predefinedCellData = WebAPIHandler.shared.allLandmarks[cell.index]
//            target.titleLable.text = cell.titlaLable.text
//            target.descriptionLabel.text = PredefinedCells[cell.index].description
//            Alamofire.request( PredefinedCells[cell.index].largeImageUrl).responseImage { response in
//                if let image = response.result.value {
//                    target.largeImageView.image = image
//                }
//            }
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

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WebAPIHandler.shared.allLandmarks.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 300)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as? HomeTableViewCell{
            cell.index = indexPath.row
            //        cell.predefinedCellData = PredefinedCells[indexPath.row]
            cell.titlaLable.text = WebAPIHandler.shared.allLandmarks[indexPath.row].landmarkName
            if let thisImageUrl = WebAPIHandler.shared.allLandmarks[indexPath.row].imageURL{
                Alamofire.request( thisImageUrl).responseImage { response in
                
                    if let image = response.result.value {
                        cell.smallImageView.image = image
                    }
                }
           
            }else{
                Alamofire.request( "https://www.freeiconspng.com/uploads/no-image-icon-11.PNG").responseImage { response in
                    
                    if let image = response.result.value {
                        cell.smallImageView.image = image
                    }
                }
            }
             return cell
        }
        // Configure the cell...
        return UITableViewCell()
    }
    
    
}

