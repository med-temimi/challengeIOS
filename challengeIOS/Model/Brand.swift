//
//  Brand.swift
//  challengeIOS
//
//  Created by Mohamed on 26/11/2022.
//

import Foundation

class Brand {
    var categ : String
    var premium : Bool
    var pic : String
    var name : String
    var offreId : Int64
    var href : String
    var details: String
    var isNew: Bool
    
    
    init(name:String?, pic:String?, offreId:Int64?, categ:String?, premium:Bool?, href:String?, details:String?, isNew:Bool?) {
        self.name = name!
        self.pic = pic!
        self.offreId = offreId!
        self.categ = categ!
        self.premium = premium!
        self.href = href!
        self.details = details!
        self.isNew = isNew!
    }
   
}
