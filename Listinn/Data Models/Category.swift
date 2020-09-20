//
//  Category.swift
//  Listinn
//
//  Created by Yuşa Sarısoy on 20.09.2020.
//  Copyright © 2020 Yuşa Sarısoy. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}
