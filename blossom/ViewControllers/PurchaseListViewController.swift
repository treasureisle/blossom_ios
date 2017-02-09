//
//  PurchaseListViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 30..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Mixpanel

class PurchaseListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    var purchase = [Purchase]()
    var isLoading = true
    var me: Session?
    
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        me = Session.load()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchPurchase()
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseListViewCell", for: indexPath) as! PurchaseListViewCell
        let purchase = getPurchaseWithIndexPath(indexPath: indexPath)
        let profileGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PurchaseListViewController.imageTouched(sender:)))
        
        cell.thumbnailImageView.isUserInteractionEnabled = true
        cell.thumbnailImageView.addGestureRecognizer(profileGestureRecognizer)
        cell.thumbnailImageView.af_setImage(withURL: URL(string: purchase.post.imgUrl1)!)
        cell.purchaseIdLabel.text = String(purchase.id)
        cell.productNameLabel.text = purchase.post.title
        cell.colorSizeLabel.text = purchase.colorSize.name
        cell.amountLabel.text = String(purchase.amount)
        cell.sellerButton.setTitle(purchase.seller.username, for: .normal)
        cell.deliveryLabel.text = String(purchase.deliveryCode)

        return cell
    }
    
    // MARK: override
    func prepare(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentity.purchaseToDetail {
            let detailViewController = segue.destination as! DetailViewController
            
            detailViewController.postId = (sender as? Int)!
        }
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
        let purchase = getPurchaseWithIndexPath(indexPath: indexPath!)
        
        self.performSegue(withIdentifier: SegueIdentity.purchaseToDetail, sender: purchase.post.id)
    }
    
    func refreshPurchase(){
        if !isLoading {
            fetchPurchase()
        }
    }
    
    func fetchPurchase(){
        isLoading = true
        
        self.showIndicator()
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.purchase)/\(me?.id)") {
            (response, statusCode, json) -> () in
            if statusCode == 200{
                
                let purchases = json["purchase"].arrayValue
                
                for purchase in purchases{
                    self.purchase.append(Purchase(o:purchase))
                }
                self.refreshTable()
                
                self.isLoading = false
            }
            self.hideIndicator()
        }
    }
    
    func getPurchaseWithIndexPath(indexPath: IndexPath) -> Purchase{
        return purchase[purchase.count - 1 - indexPath.row]
    }
    
    
}
