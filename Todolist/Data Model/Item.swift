//
//  Item.swift
//  Todolist
//
//  Created by Stephen Selvaraj on 7/19/18.
//  Copyright © 2018 Stephen Selvaraj. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
