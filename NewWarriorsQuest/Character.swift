//
//  Character.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 17/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation
enum Race {
    case elfs, dwarfs, orcs
}
enum CharacterState {
    case alive, dead
}

class Character {
    var name: String
    var race: Race
    var lifePoint = 0
    var weapon = Weapon(name: "", attack: 0, heal: 0)
    var state: CharacterState = .alive

    init(name: String, race: Race) {
        self.name = name
        self.race = race
        switch race {
        case .elfs:
            self.lifePoint = 300
            self.weapon = .init(name: "Bow", attack: 90, heal: 50)
        case .dwarfs:
            self.lifePoint = 500
            self.weapon = .init(name: "Axe", attack: 150, heal: 0)
        case .orcs:
            self.lifePoint = 1000
            self.weapon = .init(name: "Sword", attack: 1000, heal: 0)
        }
    }
}
