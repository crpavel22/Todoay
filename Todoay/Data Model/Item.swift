//
//  Item.swift
//  Todoay
//
//  Created by Pavel Castillo on 6/18/19.
//  Copyright © 2019 Pavel Castillo. All rights reserved.
//

import Foundation

class Item : Codable{
    var title : String = "";
    var done : Bool = false;
    
    init(title: String) {
        self.title = title;
    }
}
