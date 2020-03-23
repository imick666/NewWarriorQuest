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

//---------------------------------
// MARK: - FUNCTION
//---------------------------------
    //ask what to do
    func actions(for currentPlayer: Player, to allPlayers: Game) {
        print("""
            What do you wanna do?
                1 - Attack
                2 - Heal
            """)
        if let answer = readLine() {
            switch answer {
            case "1":
                attack(from: currentPlayer, with: self, to: allPlayers)
            case "2":
                if self.race == .elfs {
                    heal(in: currentPlayer, with: self)
                } else {
                    print("Sorry, only Elfs can heal...")
                    actions(for: currentPlayer, to: allPlayers)
                }
            default:
                print("Invalid entry")
                actions(for: currentPlayer, to: allPlayers)
            }
        }
    }

    func checkIfDead() {
        if self.lifePoint <= 0 {
            self.lifePoint = 0
            self.state = .dead
        }
    }
//---------------------------------
// MARK: - Private FUNCTION
//---------------------------------
    private func attack(from currentPlayer: Player, with currentCharacter: Character, to players: Game) {
        var targetPlayer: Player {
            if players.enumerateAliveTargetPlayers(currentPlayer).count > 1 {
                return selectTargetPlayer(currentPlayer, players)
            }
            return players.enumerateAliveTargetPlayers(currentPlayer)[0]
        }

        print("select character you wanna attack : ")
        targetPlayer.showAliveCharacters()

        guard let entry = Int(readLine()!) else {
            print("Invalid entry")
            return attack(from: currentPlayer, with: currentCharacter, to: players)
        }

        switch entry {
        case 1 ... targetPlayer.enumerateAliveCharacters().count:
            targetPlayer.enumerateAliveCharacters()[entry - 1].lifePoint -= currentCharacter.weapon.attack
        default:
            print("Invalid entry")
            return attack(from: currentPlayer, with: currentCharacter, to: players)
        }
    }

    private func heal(in currentPlayer: Player, with currentCharacter: Character) {
        print("who do you wanna heal?")
        currentPlayer.showAliveCharacters()
        guard let entry = Int(readLine()!) else {
            print("Invalid entry")
            return heal(in: currentPlayer, with: currentCharacter)
        }
        switch entry {
        case 1 ... currentPlayer.enumerateAliveCharacters().count:
            currentPlayer.enumerateAliveCharacters()[entry - 1].lifePoint += currentCharacter.weapon.heal
        default:
            print("Invalid entry")
            return heal(in: currentPlayer, with: currentCharacter)
        }
    }

    //select the target player if more than 2 players
    private func selectTargetPlayer(_ currentPlayer: Player, _ players: Game) -> Player {
        players.showAliveTargetPlayers(currentPlayer)

        guard let entry = Int(readLine()!) else {
            print("Invalid entry")
            return selectTargetPlayer(currentPlayer, players)
        }
        switch entry {
        case 1 ... players.enumerateAliveTargetPlayers(currentPlayer).count:
            return players.enumerateAliveTargetPlayers(currentPlayer)[entry - 1]
        default:
            print("This player doesn't exist")
            return selectTargetPlayer(currentPlayer, players)
        }
    }
}
