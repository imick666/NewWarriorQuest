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

    //ask what to do
    func actions(for currentPlayer: Player, to allPlayers: [Player]) {
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
                heal(in: currentPlayer, with: self)
            default:
                print("Invalid entry")
                actions(for: currentPlayer, to: allPlayers)
            }
        }
    }

    private func attack(from currentPlayer: Player, with currentCharacter: Character, to allPlayers: [Player]) {
        let targetPlayer = selectTargetPlayer(currentPlayer, allPlayers)
        var targetAliveCharacter = [Character]()

        for character in targetPlayer.team where character.state == .alive {
            targetAliveCharacter.append(character)
        }
        print("select character you wanna attack : ")
        for (index, character) in targetAliveCharacter.enumerated() {
            print("\(index + 1) - \(character.name) with \(character.lifePoint) PV")
        }
        guard let entry = Int(readLine()!) else {
            print("Invalid entry")
            return attack(from: currentPlayer, with: currentCharacter, to: allPlayers)
        }

        switch entry {
        case 1 ... targetPlayer.team.count:
            targetAliveCharacter[entry - 1].lifePoint -= currentCharacter.weapon.attack
            for character in  targetAliveCharacter where character.lifePoint < 0 {
                character.lifePoint = 0
            }
        default:
            print("Invalid entry")
            return attack(from: currentPlayer, with: currentCharacter, to: allPlayers)
        }
    }

    private func heal(in currentPlayer: Player, with currentCharacter: Character) {
        var currentAliveCharacter = [Character]()

        for character in currentPlayer.team where character.state == .alive {
            currentAliveCharacter.append(character)
        }
        print("who do you wanna heal?")
        for (index, character) in currentAliveCharacter.enumerated() {
            print("\(index + 1) - \(character.name) with \(character.lifePoint) PV")
        }
        guard let entry = Int(readLine()!) else {
            print("Invalid entry")
            return heal(in: currentPlayer, with: currentCharacter)
        }
        switch entry {
        case 1 ... currentPlayer.team.count:
            currentAliveCharacter[entry - 1].lifePoint += currentCharacter.weapon.heal
        default:
            print("Invalid entry")
            return heal(in: currentPlayer, with: currentCharacter)
        }
    }

    //select the target player
    private func selectTargetPlayer(_ currentPlayer: Player, _ players: [Player]) -> Player {
        var targetList = [Player]()
        var targetIndex = Int()

        for player in players where (player.playerNumber != currentPlayer.playerNumber) && (player.state == .alive) {
            targetList.append(player)
        }
        guard targetList.count > 1 else {
            return targetList[0]
        }
        //if more than 2 players, this code is execute
        for (index, player) in targetList.enumerated() {
            print("\(index + 1) - \(player.nickname)")
        }
        guard let entry = Int(readLine()!) else {
            print("Invalid entry")
            return selectTargetPlayer(currentPlayer, players)
        }
        switch entry {
        case 1 ... targetList.count:
            targetIndex = (entry - 1)
        default:
            print("This player doesn't exist")
            return selectTargetPlayer(currentPlayer, players)
        }

        return targetList[targetIndex]
    }
}
