//
//  Item.swift
//  Listinn
//
//  Created by Yuşa Sarısoy on 20.09.2020.
//  Copyright © 2020 Yuşa Sarısoy. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
