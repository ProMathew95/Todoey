//
//  Item.swift
//  todoey
//
//  Created by macbook on 4/9/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import Foundation
import RealmSwift

class Item:Object
{
    @objc dynamic var title:String = ""
    @objc dynamic var checked:Bool = false
   var parentCategory  = LinkingObjects(fromType: Category.self, property: "items")
    
}
