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

class Character {
    var name: String
    static var namesList = [String]()
    var race: Race
    var lifePoint = 0 {
        didSet {
            if self.lifePoint < 0 {
                self.lifePoint = 0
            }
        }
    }
    var weapon = Weapon(name: "", attack: 0, heal: 0)
    var isDead: Bool {
        if lifePoint <= 0 {
            return true
        }
        return false
    }

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

//---------------------------------
// MARK: - FUNCTION
//---------------------------------
    func attack(from currentPlayer: Player, to currentTarget: Player, with currentCharacter: Character) {
        print("select character you wanna attack : ")
        currentTarget.showAliveCharacters()

        if let entry = readLine() {
            guard let index = Int(entry) else {
                print("Invalid entry")
                return attack(from: currentPlayer, to: currentTarget, with: currentCharacter)
            }

            switch index {
            case 1 ... currentTarget.enumerateAliveCharacters().count:
                currentTarget.enumerateAliveCharacters()[index - 1].lifePoint -= currentCharacter.weapon.attack
            default:
                print("Invalid entry")
                return attack(from: currentPlayer, to: currentTarget, with: currentCharacter)
            }
        }
    }
  
    func heal(with currentCharacter: Character, to currentPlayer: Player) {
        print("who do you wanna heal?")
        currentPlayer.showAliveCharacters()
        if let entry = readLine() {
            guard let index = Int(entry) else {
                print("Invalid entry")
                return heal(with: currentCharacter, to: currentPlayer)
            }
            switch index {
            case 1 ... currentPlayer.enumerateAliveCharacters().count:
                currentPlayer.enumerateAliveCharacters()[index - 1].lifePoint += currentCharacter.weapon.heal
            default:
                print("Invalid entry")
                return heal(with: currentCharacter, to: currentPlayer)
            }
        }
    }
//---------------------------------
// MARK: - Private FUNCTION
//---------------------------------
}
