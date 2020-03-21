//
//  Player.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 17/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

class Player {
    var nickname = ""
    var playerNumber = 0
    var team = [Character]()

    init(_ playerNumber: Int, in allPlayers: [Player]) {
        createPlayer(playerNumber, allPlayers: allPlayers)
    }

    private func createPlayer(_ playerNumber: Int, allPlayers: [Player]) {
        print("""
        Player \(playerNumber)
        Enter your Nickname :
        """)
        if let entry = readLine() {
            //check if player name already exist
            for player in allPlayers {
                guard entry != player.nickname else {
                    return createPlayer(playerNumber, allPlayers: allPlayers)
                }
            }
            nickname = entry
            self.playerNumber = playerNumber
        }
        //create team
        //repeat until 3 characters in the team
        repeat {
            let character = createCharacter(allPlayers: allPlayers)
            team.append(character)
        }while team.count < 3
    }
//----------------------------------------
// MARK: PRIVATE FUNCTION
//---------------------------------------

    private func createCharacter(allPlayers: [Player]) -> Character {
        var character = Character(name: "", race: .elfs)

        print("""
            It miss \(3 - team.count) characters in your team

            Choose your character:

            1 - Elf : 500 PV and 90 attack
            2 - Dwarf : 700 PV and 150 attack
            3 - Orc : 1000 PV and 100 attack
            """)
        if let entry = readLine() {
            switch entry {
            case "1":
                character = .init(name: "", race: .elfs)
            case "2":
                character = .init(name: "", race: .dwarfs)
            case "3":
                character = .init(name: "", race: .orcs)
            default:
                print("I don't understand")
                return createCharacter(allPlayers: allPlayers)
            }
        }
        character.name = namingChar(allPlayers: allPlayers)

        return character

    }

    private func namingChar(allPlayers: [Player]) -> String {
        var name = ""

        print("Give him a name : ")
        if let entry = readLine() {
            //check if name less than 3 characters
            guard entry.count > 3 else {
                print("Name is to short")
                return namingChar(allPlayers: allPlayers)
            }
            //check if name alwready used in current team
            for character in team {
                guard entry != character.name else {
                    print("name already used")
                    return namingChar(allPlayers: allPlayers)
                }
            }
            //check if name already used in all team
            for player in allPlayers {
                for character in player.team {
                    guard entry != character.name else {
                        print("name already used")
                        return namingChar(allPlayers: allPlayers)
                    }
                }
            }
            //pickup name
            name = entry
        }
        return name
    }
}
