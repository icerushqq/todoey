//
//  Category.swift
//  todoey
//
//  Created by 李俊澔 on 2018/3/15.
//  Copyright © 2018年 icerushqq. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
