//
//  Character.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 17/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation
enum Race{
    case Elfs, Dwarfs, Orcs
}

class Character{
    var name: String
    var race: Race
    var pv = 0
    var weapon = Weapon(name: "", attack: 0, heal: 0)
    
    init(name: String, race: Race){
        self.name = name
        self.race = race
        switch race {
        case .Elfs:
            self.pv = 300
            self.weapon = .init(name: "Bow", attack: 90, heal: 50)
        case .Dwarfs:
            self.pv = 500
            self.weapon = .init(name: "Axe", attack: 150, heal: 0)
        case .Orcs:
            self.pv = 1000
            self.weapon = .init(name: "Sword", attack: 100, heal: 0)
        }
    }
    
}
