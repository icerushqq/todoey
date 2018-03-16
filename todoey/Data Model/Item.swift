//
//  Item.swift
//  todoey
//
//  Created by 李俊澔 on 2018/3/15.
//  Copyright © 2018年 icerushqq. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = true
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

