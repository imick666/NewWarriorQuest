//
//  Weapon.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 17/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation
class Weapon {
    var name: String
    var attack: Int
    var heal: Int

    init(name: String, attack: Int, heal: Int) {
        self.name = name
        self.attack = attack
        self.heal = heal
    }
}

class RandomWeapon: Weapon {
    let randomName = ["Super-Bow", "Super-Axe", "Super-Sword", "Basic-Spell"]
    let randomAttack = Int.random(in: 0 ... 500)
    let randomHeal = Int.random(in: 0 ... 1000)

    override init(name: String, attack: Int, heal: Int) {
        super.init(name: randomName.randomElement()!, attack: randomAttack, heal: randomHeal)
    }
}
