//
//  Category.swift
//  Todoay
//
//  Created by Pavel Castillo on 7/2/19.
//  Copyright © 2019 Pavel Castillo. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = "";
    let items = List<Item>();
}
