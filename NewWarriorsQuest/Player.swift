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
//----------------------------------------
// MARK: PRIVATE FUNCTION
//----------------------------------------
// MARK: Create Players Function
//----------------------------------------
    private func createPlayer(_ playerNumber: Int) {
        print("""
        
        Player \(playerNumber) Enter your Nickname :
        """)
        if let entry = readLine() {
            //check if player name already exist
            guard !Player.nicknameList.contains(entry.lowercased()) && !Character.namesList.contains(entry.lowercased()) else {
                print("!! this name already exist !!")
                return createPlayer(playerNumber)
            }
            Player.nicknameList.append(entry.lowercased())
            nickname = entry.lowercased()
            self.playerNumber = playerNumber
        }
        //create team
        //repeat until 3 characters in the team
        repeat {
            team.append(createCharacter())
        }while team.count < 3
        
        print("""
        
        \(String(repeating: "-", count: nickname.count + 33))
        --- \(nickname): You're team is complete ---
        \(String(repeating: "-", count: nickname.count + 34))
        """)
    }

    private func createCharacter() -> Character {
        var character = Character(name: "", race: .elfs)

        print("""
        
        \(String(repeating: "-", count: 44))
        --- It missing \(3 - team.count) characters in your team ---
        \(String(repeating: "-", count: 44))

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
                print("!! Name is to short !!")
                return namingChar()
            }
            //check if name alwready used in current team
            guard !Player.nicknameList.contains(entry.lowercased()) && !Character.namesList.contains(entry.lowercased()) else {
                print("!! this name already exist !!")
                return namingChar()
            }
            Character.namesList.append(entry.lowercased())
            //pickup name
            return entry.lowercased()
        }
        return namingChar()
    }
}
