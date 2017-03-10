//
//  PurchaseViewController.swift
//  blossom
//
//  Created by Seong Phil on 2017. 1. 11..
//  Copyright © 2017년 treasureisle. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Mixpanel

class PurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    var orders = [Order]()
    var isLoading = true
    var me: Session?
    var userDetail: UserDetail!
    
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var savedAddressButton: UIButton!
    @IBOutlet weak var recentAddressButton: UIButton!
    @IBOutlet weak var newAddressButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressDetailTextField: UITextField!
    @IBOutlet weak var recieverTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    
    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        me = Session.load()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.touches(_:))))
        
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.userDetail)/\(me!.id)", completionHandler: {
            (response, statusCode, json) -> () in
            if statusCode == 200 {
                self.userDetail = UserDetail(o: json["user_detail"])
                if self.userDetail.address1.isEmpty {
                    if self.userDetail.recent_add1.isEmpty {
                        self.savedAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
                        self.recentAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
                        self.newAddressButton.setTitleColor(UIColor.blue, for: .normal)
                        self.addressTextField.isEnabled = true
                        self.addressDetailTextField.isEnabled = true
                        self.recieverTextField.isEnabled = true
                        self.phoneTextField.isEnabled = true
                    } else {
                        self.savedAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
                        self.recentAddressButton.setTitleColor(UIColor.blue, for: .normal)
                        self.newAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
                        self.addressTextField.text = self.userDetail.recent_add1
                        self.addressDetailTextField.text = self.userDetail.recent_add2
                        self.recieverTextField.text = self.userDetail.recent_name
                        self.phoneTextField.text = self.userDetail.recent_phone
                        self.addressTextField.isEnabled = false
                        self.addressDetailTextField.isEnabled = false
                        self.recieverTextField.isEnabled = false
                        self.phoneTextField.isEnabled = false
                    }
                } else {
                    self.savedAddressButton.setTitleColor(UIColor.blue, for: .normal)
                    self.recentAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
                    self.newAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
                    self.addressTextField.text = self.userDetail.address1
                    self.addressDetailTextField.text = self.userDetail.address2
                    self.recieverTextField.text = self.userDetail.name
                    self.phoneTextField.text = self.userDetail.phone
                    self.addressTextField.isEnabled = false
                    self.addressDetailTextField.isEnabled = false
                    self.recieverTextField.isEnabled = false
                    self.phoneTextField.isEnabled = false
                }
            }
        })
    }
    
    func touches(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseViewCell", for: indexPath) as! PurchaseViewCell
        let order = getOrderWithIndexPath(indexPath: indexPath)
        let detailGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PurchaseViewController.imageTouched(sender:)))
        let profileGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PurchaseViewController.sellerTouched(sender:)))
        
        cell.thumbnailImageView.isUserInteractionEnabled = true
        cell.thumbnailImageView.addGestureRecognizer(detailGestureRecognizer)
        cell.thumbnailImageView.af_setImage(withURL: URL(string: order.post.imgUrl1)!)
        cell.sellerLabel.isUserInteractionEnabled = true
        cell.sellerLabel.addGestureRecognizer(profileGestureRecognizer)
        cell.productNameLabel.text = order.post.title
        cell.colorSizeLabel.text = order.colorSize.name
        cell.amountLabel.text = String(order.amount)
        cell.sellerLabel.text = order.post.user.username
        
        return cell
    }
    
    // MARK: override
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.purchaseToDetail {
            let detailViewController = segue.destination as! DetailViewController
            let postId = sender as! Int
            detailViewController.postId = postId
        } else if segue.identifier == SegueIdentity.purchaseToProfile {
            let profileViewController = segue.destination as! ProfileViewController
            let userId = sender as! Int
            profileViewController.userId = userId
        }
    }
    
    // MARK: IBAction
    @IBAction func cancelTouched() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savedAddressTouched(){
        self.savedAddressButton.setTitleColor(UIColor.blue, for: .normal)
        self.recentAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.newAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.addressTextField.text = self.userDetail.address1
        self.addressDetailTextField.text = self.userDetail.address2
        self.recieverTextField.text = self.userDetail.name
        self.phoneTextField.text = self.userDetail.phone
        self.addressTextField.isEnabled = false
        self.addressDetailTextField.isEnabled = false
        self.recieverTextField.isEnabled = false
        self.phoneTextField.isEnabled = false
    }
    
    @IBAction func recentAddressTouched(){
        self.savedAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.recentAddressButton.setTitleColor(UIColor.blue, for: .normal)
        self.newAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.addressTextField.text = self.userDetail.recent_add1
        self.addressDetailTextField.text = self.userDetail.recent_add2
        self.recieverTextField.text = self.userDetail.recent_name
        self.phoneTextField.text = self.userDetail.recent_phone
        self.addressTextField.isEnabled = false
        self.addressDetailTextField.isEnabled = false
        self.recieverTextField.isEnabled = false
        self.phoneTextField.isEnabled = false
    }
    
    @IBAction func newAddressTouched(){
        self.savedAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.recentAddressButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.newAddressButton.setTitleColor(UIColor.blue, for: .normal)
        self.addressTextField.isEnabled = true
        self.addressDetailTextField.isEnabled = true
        self.recieverTextField.isEnabled = true
        self.phoneTextField.isEnabled = true
        self.addressTextField.text = ""
        self.addressDetailTextField.text = ""
        self.recieverTextField.text = ""
        self.phoneTextField.text = ""
    }
    
    // MARK: custom
    func scrollToLast(){
        tableView.scrollRectToVisible(CGRect.init(x: 1, y: 1, width: tableView.contentSize.width - 1, height: tableView.contentSize.height - 1), animated: false)
    }
    
    func refreshTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.scrollToLast()
            return
        }
    }
    
    func imageTouched(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        let purchase = getOrderWithIndexPath(indexPath: indexPath!)
        print("1.postId: \(purchase.post.id)")
        
        self.performSegue(withIdentifier: SegueIdentity.purchaseToDetail, sender: purchase.post.id)
    }
    
    func sellerTouched(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        let purchase = getOrderWithIndexPath(indexPath: indexPath!)
        print("1.userId: \(purchase.post.user.id)")
        
        self.performSegue(withIdentifier: SegueIdentity.purchaseToProfile, sender: purchase.post.user.id)
    }

    func getOrderWithIndexPath(indexPath: IndexPath) -> Order{
        return orders[orders.count - 1 - indexPath.row]
    }
    
    
}
