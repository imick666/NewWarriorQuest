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
    static var nicknameList = [String]()
    var playerNumber = 0
    var team = [Character]()
    var isDead: Bool {
        var count: Int {
            for character in team where !character.isDead {
                return +1
            }
            return +0
        }
        guard count > 0 else {
            return true
        }
        return false
    }

    init(_ playerNumber: Int) {
        createPlayer(playerNumber)
    }
//---------------------------------
// MARK: - FUNCTION
//---------------------------------
    //select character to use
    func selectCharacter() -> Character {
        print("Select your character :")
        showAliveCharacters()
        if let entry = readLine() {
            guard let index = Int(entry) else {
                print("Invalid entry, please choose a character")
                return selectCharacter()
            }
            switch index {
            case 1 ... enumerateAliveCharacters().count:
                return enumerateAliveCharacters()[index - 1]
            default:
                print("This character doesn't exist")
                return selectCharacter()
            }
        }
        return selectCharacter()
    }

    func enumerateAliveCharacters() -> [Character] {
        var aliveCharacters = [Character]()

        for character in self.team where !character.isDead {
            aliveCharacters.append(character)
        }
        return aliveCharacters
    }

    func showAliveCharacters() {
        for (index, character) in enumerateAliveCharacters().enumerated() {
            print("""
            \(index + 1) : \(character.name)
            PV : \(character.lifePoint) | Attack : \(character.weapon.attack)
            """)
        }
    }

    //ask what to do
    func actions(from currentPlayer: Player, with currentCharacter: Character, to currentTarget: Player) {
        switch currentTarget.playerNumber == currentPlayer.playerNumber {
        case true:
            currentCharacter.heal(with: currentCharacter, to: currentTarget)
        case false:
            currentCharacter.attack(from: currentPlayer, to: currentTarget, with: currentCharacter)
        }
    }
//----------------------------------------
// MARK: PRIVATE FUNCTION
//----------------------------------------
// MARK: Create Players Function
//----------------------------------------
    private func createPlayer(_ playerNumber: Int) {
        print("""
        Player \(playerNumber)
        Enter your Nickname :
        """)
        if let entry = readLine() {
            //check if player name already exist
            for name in Player.nicknameList {
                guard entry != name else {
                    print("nickname already exist")
                    return createPlayer(playerNumber)
                }
            }
            Player.nicknameList.append(entry)
            nickname = entry
            self.playerNumber = playerNumber
        }
        //create team
        //repeat until 3 characters in the team
        repeat {
            team.append(createCharacter())
        }while team.count < 3
    }

    private func createCharacter() -> Character {
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
                return createCharacter()
            }
        }
        character.name = namingChar()

        return character

    }

    private func namingChar() -> String {
        print("Give him a name : ")
        if let entry = readLine() {
            //check if name less than 3 characters
            guard entry.count > 3 else {
                print("Name is to short")
                return namingChar()
            }
            //check if name alwready used in current team
            for name in Character.namesList {
                guard entry != name else {
                    print("name already used")
                    return namingChar()
                }
            }
            Character.namesList.append(entry)
            //pickup name
            return entry
        }
        return namingChar()
    }
}
