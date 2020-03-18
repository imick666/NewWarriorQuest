//
//  Weapon.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 17/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation
class Weapon{
    var name: String
    var attack: Int
    var heal: Int
    
    init(name: String, attack: Int, heal: Int) {
        self.name = name
        self.attack = attack
        self.heal = heal
    }
}
