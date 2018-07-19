//
//  Category.swift
//  Todolist
//
//  Created by Stephen Selvaraj on 7/19/18.
//  Copyright © 2018 Stephen Selvaraj. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
