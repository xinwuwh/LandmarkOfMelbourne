//
//  SelectLableViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 23/10/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit

class SelectLableViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    public var image: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectLableViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WebAPIHandler.shared.allStreetView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "selectLabelCell") as? SelectLabelTableCell{
            cell.streetViewName.text = WebAPIHandler.shared.allStreetView[indexPath.row].streetViewName
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let streetView = WebAPIHandler.shared.allStreetView[indexPath.row]
        WebAPIHandler.shared.uploadAndMarkLabel(labelName: streetView.streetViewName!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!, image: imageView.image!){ response in
            switch response.result{
            case .failure(let error):
                print(error.localizedDescription)
                UIFuncs.popUp(title: "Error", info: "Loading street view data failed, \(String(data: response.data!, encoding: String.Encoding.utf8)!)", type: UIFuncs.BlockPopType.warning , sender: self, callback: {})
            case .success( _):
                 UIFuncs.popUp(title: "Succ", info: "Thanks for your contribution!", type: UIFuncs.BlockPopType.success , sender: self, callback: {})
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
}
