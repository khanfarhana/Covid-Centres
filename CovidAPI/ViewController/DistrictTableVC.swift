//
//  DistrictTableVC.swift
//  CovidAPI
//
//  Created by Farhana Khan on 12/05/21.
//

import UIKit
import Alamofire
class DistrictTableVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    var district = [NSDictionary]()
    var stateID = Int()
    @IBOutlet weak var TV: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return district.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let id = district[indexPath.row].value(forKey: "district_id") as? Int ?? 0
        cell.textLabel?.text = "ID: \(id)"
        let name = district[indexPath.row].value(forKey: "district_name") as? String ?? "Empty"
        cell.detailTextLabel?.text = "District: \(name)"
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DistrictVC") as! DistrictVC
        let id = district[indexPath.row].value(forKey: "district_id") as? Int ?? 0
        vc.text = "\(id)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actInd.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeBtn))
        self.navigationItem.title = "District"
        api()
    }
    func api()
    {
        AF.request("https://cdn-api.co-vin.in/api/v2/admin/location/districts/\(stateID)").responseJSON{(resp) in
            if let  data = resp.value as? NSDictionary {
                self.actInd.stopAnimating()
                self.district = data.value(forKey: "districts") as! [NSDictionary]
                print(self.district)
                self.TV.reloadData()
            }
            else {
                print("error ")
            }
        }
    }
    @objc func  homeBtn() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
