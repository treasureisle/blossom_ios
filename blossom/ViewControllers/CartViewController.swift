//
//  CartViewController.swift
//  blossom
//
//  Created by Seong Phil on 2016. 12. 30..
//  Copyright © 2016년 treasureisle. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Mixpanel

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    var basket = [Basket]()
    
    var isChecked = [Bool]()
    var isLoading = true
    var me: Session?
    
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func purchaseTouched() {
        purchaseItems()
    }
    
    @IBAction func cancelTouched() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.me = Session.load()
        
        fetchBasket()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketViewCell", for: indexPath) as! BasketViewCell
        let basket = self.basket[indexPath.row]
        let profileGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CartViewController.imageTouched(sender:)))
        
        cell.thumbnailImageView.isUserInteractionEnabled = true
        cell.thumbnailImageView.addGestureRecognizer(profileGestureRecognizer)
        cell.thumbnailImageView.af_setImage(withURL: URL(string: basket.post.imgUrl1)!)
        
        cell.productNameLabel.text = basket.post.productName
        
        self.showIndicator()
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.colorSize)/\(basket.post.id)") {
            (response, statusCode, json) -> () in
            if statusCode == 200{
                
                let colorsizes: Array<JSON>= json["color_sizes"].arrayValue
                
                for colorsize in colorsizes{
                    let temp = ColorSize(o:colorsize)
                    cell.colorSizes.append(temp)
                    cell.colorSizeNames.append(temp.name)
                    cell.colorSizeAvailable.append(String(temp.available))
                    
                }

                cell.checkButton.tag = indexPath.row
                cell.checkButton.addTarget(self, action: #selector(self.checkItem(sender:)), for: .touchUpInside)
                
                cell.colorSizeNamesDownPicker = DownPicker(textField: cell.colorSizeNamesTextField, withData: cell.colorSizeNames)
                cell.setSelectedFunc()
                
                cell.colorSizeNamesDownPicker.text = basket.colorSize.name
                cell.selectedColorSize = basket.colorSize
                
                var colorSizeAvailable = [String]()
                
                for i in (0..<basket.colorSize.available){
                    colorSizeAvailable.append(String(i+1))
                }
                
                cell.colorSizeAmountDownPicker = DownPicker(textField: cell.colorSizeAmountTextField, withData: colorSizeAvailable)
                
                cell.colorSizeAmountDownPicker.text = "\(basket.amount)"
                cell.selectedAmount = basket.amount
                
                self.isLoading = false
            }
            self.hideIndicator()
        }
        
        return cell
    }
    
    // MARK: override
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentity.cartToDetail {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.postId = (sender as? Int)!
        } else if segue.identifier == SegueIdentity.cartToPurchase {
            let purchaseViewController = segue.destination as! PurchaseViewController
            purchaseViewController.orders = (sender as? [Order])!
        }
    }
    
    // MARK: custom
    func checkItem(sender: UIButton) {
        if self.isChecked[sender.tag] {
            self.isChecked[sender.tag] = false
            sender.setImage(UIImage(named: ImageName.check_unchecked), for: .normal)
        } else {
            self.isChecked[sender.tag] = true
            sender.setImage(UIImage(named: ImageName.check_checked), for: .normal)
        }
    }
    
    func purchaseItems(){
        var order = [Order]()
        for i in (0..<self.isChecked.count){
            if self.isChecked[i] {
                let cellIndexPath = IndexPath(row: i, section: 0)
                let cell = tableView.cellForRow(at: cellIndexPath) as! BasketViewCell
                let newOrder = Order(post: self.basket[i].post, colorSize: cell.selectedColorSize!, amount: cell.selectedAmount)
                print("item: \(newOrder.post.title)")
                
                order.append(newOrder)
            }
        }
        performSegue(withIdentifier: SegueIdentity.cartToPurchase, sender: order)
    }
    
    func refreshTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        return
        }
    }
    
    func deleteBasket(indexPath: IndexPath) {
        let basket = self.basket[indexPath.row]
        
        // 삭제확인
        let alert = BlossomAlertController(message: "Do you want to delete your reply?")
        alert.addAction(action: BlossomAlertAction(title: "Cancel", style: .Positive, handler: nil))
        alert.addAction(action: BlossomAlertAction(title: "Yes", style: .Negative, handler: {
            action in
            _ = BlossomRequest.request(method:.delete, endPoint: "\(Api.basket)/\(basket.id)") { (response, statusCode, json) -> () in
                if statusCode == 200{
                    self.refreshBasket()
                } else {
                    self.view.makeSomethingWrongToast()
                }
                self.hideIndicator()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imageTouched(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        let basket = self.basket[indexPath!.row]
        
        self.performSegue(withIdentifier: SegueIdentity.cartToDetail, sender: basket.post.id)
    }
    
    func refreshBasket(){
        if !isLoading {
            fetchBasket()
        }
    }
    
    func fetchBasket(){
        isLoading = true
        
        self.showIndicator()
        _ = BlossomRequest.request(method: .get, endPoint: "\(Api.basket)") {
            (response, statusCode, json) -> () in
            if statusCode == 200{

                let baskets = json["basket"].arrayValue

                for basket in baskets{
                    self.basket.append(Basket(o:basket))
                    self.isChecked.append(false)
                }
                self.refreshTable()
                
                self.isLoading = false
            }
            self.hideIndicator()
        }
    }
}

