//
//  DetailsBrandViewController.swift
//  challengeIOS
//
//  Created by sami on 26/11/2022.
//

import UIKit
import SDWebImage
import Firebase

class DetailsBrandViewController: UIViewController {
    
    @IBOutlet var imgBrand: UIImageView!
    @IBOutlet var nameBrand: UILabel!
    @IBOutlet var aboutBrand: UILabel!
    
    @IBOutlet var viewChiffreAffaire: UIView!
    @IBOutlet var viewCommission: UIView!
    
    @IBOutlet var ciffreAffaireLbl: UILabel!
    @IBOutlet var commissionLbl: UILabel!
    @IBOutlet var nbVenteLbl: UILabel!
    
    var brand:Brand?
    
    let rootRef = Database.database().reference()
    
    var totalAmount = 0.0
    var countVente = 0
    var totalCommission = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.brand != nil {
            DispatchQueue.main.async {
                self.getChiffers()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.text = "Accueil"
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        if self.navigationItem.leftBarButtonItems!.count < 2 {
            self.navigationItem.leftBarButtonItems?.append(UIBarButtonItem.init(customView: label))
        }
        
        if self.brand != nil {
            self.nameBrand.text = self.brand!.name
            self.aboutBrand.text = self.brand!.details
            let url = self.brand!.pic
            autoreleasepool {
                self.imgBrand.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
            }
            
        }
        
    }
    
    private func updateData(){
        self.ciffreAffaireLbl.text = "\(String(format: "%.1f", self.totalAmount))€"
        self.commissionLbl.text = "\(String(format: "%.1f", self.totalCommission))€"
        self.nbVenteLbl.text = "\(self.countVente)"
    }
    
    
    @IBAction func getBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func getChiffers(){
        rootRef
            .child("conversions")
            .child("purchase")
            .queryOrdered(byChild: "offerId")
            .queryEqual(toValue: self.brand?.offreId)
            .observe(.value, with: { (snapshot) -> Void in
                self.countVente = Int(snapshot.childrenCount)
                if snapshot.childrenCount > 0{
                    for purchases in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let purchase = purchases.value as! [String: Any]
                    
                        if let val_amount = purchase["amount"] as? Double {
                            self.totalAmount  += val_amount
                        }
                        
                        if let val_commission = purchase["commission"] as? String {
                            self.totalCommission  += Double(val_commission)!
                        }
                    }
                    self.updateData()
                }
            })
    }
}
