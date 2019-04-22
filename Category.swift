//
//  Category.swift
//  todoey
//
//  Created by macbook on 4/22/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object
{
   @objc dynamic var name :String = ""
    @objc dynamic var color:String = ""
   let items = List<Item>()
    
}
