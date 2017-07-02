//
//  User.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/14/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import Foundation
class PlayStation: NSObject ,NSCoding{
    
    var name: String
    var phone: String
    var location: Location
    
    init(data : NSDictionary) {
        self.name = data.getValueForKey(Key: "name", callBack: "")
        self.phone = data.getValueForKey(Key: "phoneNumber", callBack: "")
        self.location = Location(data: data.getValueForKey(Key: "location" , callBack: [:]))        
    }
    override init() {
        self.name = ""
        self.phone = ""
        self.location = Location()
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        phone = aDecoder.decodeObject(forKey: "Phone") as! String
        location = aDecoder.decodeObject(forKey: "Location") as! Location
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(phone, forKey: "Phone")
        aCoder.encode(location, forKey: "Location")
        
    }
    
}
