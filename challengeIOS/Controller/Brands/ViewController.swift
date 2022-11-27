//
//  ViewController.swift
//  challengeIOS
//
//  Created by Mohamed on 26/11/2022.
//

import UIKit
import Firebase
import Lottie
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet var premiumMarqueView: UIView!
    @IBOutlet var allMarqueView: UIView!
    
    @IBOutlet var premiumMarqueLbl: UILabel!
    @IBOutlet var allMarqueLbl: UILabel!
    
    @IBOutlet var premiumMarquebtm: UIView!
    @IBOutlet var allMarqueBtm: UIView!
    
    @IBOutlet var brandsCollectionView: UICollectionView!
    @IBOutlet var viewLoading: UIView!
    
    var brandsList = [Brand]()
    var premiumBrandsList = [Brand]()
    var isPremiumSelected:Bool = true
    
    let animationView = AnimationView()
    
    var refresher: UIRefreshControl!
    
    let rootRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.setupAnimation()
        self.setGesture()
        DispatchQueue.main.async {
            self.getBrands()
        }
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshSwip), for: .valueChanged)
        brandsCollectionView.refreshControl = refresher
        
    }
    
    @objc func refreshSwip(){
        DispatchQueue.main.async {
            self.getBrands()
        }
        refresher.endRefreshing()
    }
    
    
    private func setupAnimation(){
        
        self.brandsCollectionView.isHidden = true
        animationView.animation = Animation.named("waiting")
        animationView.frame = self.viewLoading.bounds
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        viewLoading.addSubview(animationView)
    }
    
    private func setGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.premiumMarques(_:)))
        self.premiumMarqueView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.allMarques(_:)))
        self.allMarqueView.addGestureRecognizer(tap2)
    }
    
    private func getBrands(){
        rootRef
        .child("brands")
        .observe(.value, with: { (snapshot) -> Void in
            if snapshot.childrenCount > 0{
                self.brandsList.removeAll()
                
                for brands in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let brandObject = brands.value as! [String: Any]
                    
                    print("-------- brand object: ")
                    print(brandObject)
                    
                    let brandName = brandObject["name"] as! String
                    let brandCateg = "category"
                    
                    var brandDetails = ""
                    if let details = brandObject["description"] as? String{
                        brandDetails = details
                    }
                    
                    var brandPremium = false
                    if brandObject["premium"] != nil {
                        if let premium = brandObject["premium"] as? Bool{
                            brandPremium = premium
                        }
                    }
                    
                    var brandIsNew = false
                    if brandObject["isNew"] != nil {
                        if let isNew = brandObject["isNew"] as? Bool{
                            brandIsNew = isNew
                        }
                    }
                    
                    var brandPic = ""
                    if brandObject["pic"] != nil {
                        brandPic = brandObject["pic"] as! String
                    }
                    
                    let brandOffreId = brandObject["offerId"] as! Int64
                    
                    var brandHref = ""
                    if brandObject["href"] != nil {
                        brandHref = brandObject["href"] as! String
                    }
                    
                    let brand = Brand(name: brandName, pic: brandPic, offreId: brandOffreId, categ: brandCateg, premium: brandPremium, href: brandHref, details: brandDetails, isNew: brandIsNew)
                    self.brandsList.append(brand)
                    
                }
                self.fetchPremium()
            }
        })
        
    }
    
    private func fetchPremium(){
        
        for item in self.brandsList {
            if item.premium {
                self.premiumBrandsList.append(item)
            }
        }
        
        DispatchQueue.main.async {
            self.brandsCollectionView.isHidden = false
            self.brandsCollectionView.reloadData()
        }
        
    }
    
    @objc func premiumMarques(_ sender: UITapGestureRecognizer? = nil) {
        self.premiumMarqueLbl.textColor = .systemTeal
        self.premiumMarquebtm.backgroundColor = .systemTeal
        self.isPremiumSelected = true
        self.allMarqueLbl.textColor = .black
        self.allMarqueBtm.backgroundColor = .white
        DispatchQueue.main.async {
            self.brandsCollectionView.reloadData()
        }
    }
    
    @objc func allMarques(_ sender: UITapGestureRecognizer? = nil) {
        self.allMarqueLbl.textColor = .systemTeal
        self.allMarqueBtm.backgroundColor = .systemTeal
        self.isPremiumSelected = false
        self.premiumMarqueLbl.textColor = .black
        self.premiumMarquebtm.backgroundColor = .white
        DispatchQueue.main.async {
            self.brandsCollectionView.reloadData()
        }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        
        let alert = UIAlertController(title: "Se deconnecter!", message: "Voulez vous vraiment se deconnecter !", preferredStyle: .alert)
        
        let oKBtn = UIAlertAction(title: "Confirmer", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            print("------- confirmed logout ")
            do{
                try FirebaseAuth.Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                self.navigationController?.pushViewController(signInVC, animated: true)
            }catch{
                print("---- an error occured when sign out ! ")
            }
        })
        
        let cancelBtn = UIAlertAction(title: "Annuler", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        
        alert.addAction(oKBtn)
        alert.addAction(cancelBtn)
        self.present(alert, animated: true)
        
    }
    
    
    
}


extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("------- count all brands : \(self.brandsList.count)")
        
        if self.isPremiumSelected {
            print("------- count premium: \(self.premiumBrandsList.count)")
            return self.premiumBrandsList.count
        }else{
            return self.brandsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var brand:Brand!
        if self.isPremiumSelected {
            brand = self.premiumBrandsList[indexPath.row]
        }else{
            brand = self.brandsList[indexPath.row]
        }
        var cell: BrandCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCollectionViewCell", for: indexPath) as! BrandCollectionViewCell
        
        autoreleasepool {
            cell.imgBrand.sd_setImage(with: URL(string: brand.pic), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        cell.imgBrand.applyshadowWithCorner(containerView: cell.imgBrand, cornerRadious: 8.0)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var brand:Brand!
        if self.isPremiumSelected {
            brand = self.premiumBrandsList[indexPath.row]
        }else{
            brand = self.brandsList[indexPath.row]
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsBrandVC = storyboard.instantiateViewController(withIdentifier: "DetailsBrandViewController") as! DetailsBrandViewController
        detailsBrandVC.brand = brand
        self.navigationController?.pushViewController(detailsBrandVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.brandsCollectionView.bounds.width * 0.31
        
        return CGSize(width: height, height: height)
        
    }
    
    
}

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            self.init(data: try Data(contentsOf: url))
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
