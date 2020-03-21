//
//  Game.swift
//  NewWarriorsQuest
//
//  Created by mickael ruzel on 17/03/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

enum State {
    case ongoing, over
}
//--------------------------
// MARK: - GAME
//---------------------------
class Game {
    var players = [Player]()
    var nbPlayers = 0
    var state: State = .over
    var score = Score()

    init() {
        //--------------------------------
        // MARK: Create Players
        //--------------------------------
        //pickup numbers of players
        //repeat until less than 2 players
        repeat {
            print("How many player are you?")
            guard let entry = Int(readLine()!) else {
                continue
            }
            nbPlayers = entry
        }while nbPlayers < 2
        //create players card
        //repeat for the number of player
        for playerNumber in 1 ... nbPlayers {
            let playerX = Player(playerNumber, in: players)
            players.append(playerX)
            score.players.append(playerX)
        }

        showTeams()
        print("\n---FIGHT---\n")
        //--------------------------
        // MARK: FIGHT
        //--------------------------
        state = .ongoing
        var loop = 0
        repeat {
            //count rounds
            //add one round evry time all player have play
            loop += 1
            if loop % players.count == 1 {
                score.round += 1
            }
            //show round number
            print("ROUND \(score.round)")
            //switch on each player to each round
            let currentPlayer = players[0]
            //print the current player
            print("Player \(currentPlayer.playerNumber) : \(currentPlayer.nickname) ")
            // ternary condition for make apears random weapon with 25% of chance
            _ = Int.random(in: 0 ... 100) <= 25 ? randomWeaponAppear(for: currentPlayer) : nil
            //select the current character
            let currentCharacter = selectCharacter(currentPlayer)
            //show wich character have been choose
            print(currentCharacter.name)
            //ask wich action to do
            actions(for: currentPlayer, with: currentCharacter)
            //check if characters are dead or if the game is over and switch player
            checkState(currentPlayer)
            guard players.count > 1 else {
                state = .over
                break
            }
            //test score-------------------
            for player in score.players {
                print(player.nickname)
                for hero in player.team {
                    print(hero.name)
                }
            }
            //------------------------------
        }while state == .ongoing
    }

    //-------------------------------------
    // MARK: - PRIVATE FUNCTION
    //-------------------------------------
    // MARK: Utilities
    //-------------------------------------
    private func showTeams() {
        for player in players {
            print("\nPlayer \(player.playerNumber) | Nickname : \(player.nickname)")
            for character in player.team {
                print("\(character.name) :PV : \(character.lifePoint) | Attack : \(character.weapon.attack)")
            }
        }
    }

    private func checkState(_ currentPlayer: Player) {
        for (index, player) in players.enumerated() {
            for (index, character) in player.team.enumerated() where character.lifePoint <= 0 {
                player.team.remove(at: index)
            }
            if player.team.isEmpty {
                players.remove(at: index)
            }
        }
        players.append(currentPlayer)
        players.remove(at: 0)
    }

    private func randomWeaponAppear(for currentPlayer: Player) {
        let randomWeapon = RandomWeapon(name: "", attack: 0, heal: 0)

        print("""
            A new weapon is appear!!!!
            Do you wanna assign \(randomWeapon.name) to a character?
            Y / N
        """)
        if let entry = readLine() {
            switch entry {
            case "y", "Y":
                print("Wich character will use this weapon?")
                for (index, character) in currentPlayer.team.enumerated() {
                    print("\(index + 1) - \(character.name) with \(character.weapon.attack)"
                        + "Attack and \(character.weapon.heal) Heal capacity")
                }
                guard let entry = Int(readLine()!) else {
                    print("Invalid entry")
                    return randomWeaponAppear(for: currentPlayer)
                }
                switch entry {
                case 1 ... currentPlayer.team.count:
                    currentPlayer.team[entry - 1].weapon = randomWeapon
                    print("Character \(currentPlayer.team[entry - 1].name) have now \(randomWeapon.attack)"
                        + "of attack and \(randomWeapon.heal) of heal capacity!")
                default:
                    print("This character doesn't exist.")
                    return randomWeaponAppear(for: currentPlayer)
                }
            case "n", "N":
                print("As you want, the weapon is destroy")
            default:
                print("Invalid entry")
                return randomWeaponAppear(for: currentPlayer)
            }
        }
    }

    //select character to use
    private func selectCharacter(_ currentPlayer: Player) -> Character {
        var characterIndex = 0

        print("Select your character :")
        for (index, character) in currentPlayer.team.enumerated() {
            print("""
                \(index + 1) : \(character.name)
                PV : \(character.lifePoint) | Attack : \(character.weapon.attack)
                """)
        }
        guard let entry = Int(readLine()!) else {
            print("Invalid entry, please choose a character")
            return selectCharacter(currentPlayer)
        }
        switch entry {
        case 1 ... currentPlayer.team.count:
            characterIndex = (entry - 1)
        default:
            print("This character doesn't exist")
            return selectCharacter(currentPlayer)
        }

        return currentPlayer.team[characterIndex]
    }
    //----------------------------------------
    // MARK: Actions
    //----------------------------------------
    //ask what to do
    private func actions(for currentPlayer: Player, with currentCharacter: Character) {
        print("""
            What do you wanna do?
                1 - Attack
                2 - Heal
        """)
        if let answer = readLine() {
            switch answer {
            case "1":
                attack(from: currentPlayer, with: currentCharacter)
            case "2":
                heal(in: currentPlayer, with: currentCharacter)
            default:
                print("Invalid entry")
                actions(for: currentPlayer, with: currentCharacter)
            }
        }
    }

    private func attack(from currentPlayer: Player, with currentCharacter: Character) {
        let targetPlayer = selectTargetPlayer(currentPlayer)

        print("select character you wanna attack : ")
        for (index, character) in targetPlayer.team.enumerated() {
            print("\(index + 1) - \(character.name) with \(character.lifePoint) PV")
        }
        guard let entry = Int(readLine()!) else {
            print("Invalid entry")
            return attack(from: currentPlayer, with: currentCharacter)
        }

        switch entry {
        case 1 ... targetPlayer.team.count:
            targetPlayer.team[entry - 1].lifePoint -= currentCharacter.weapon.attack
        default:
            print("Invalid entry")
            return attack(from: currentPlayer, with: currentCharacter)
        }
    }

    private func heal(in currentPlayer: Player, with currentCharacter: Character) {
        print("who do you wanna heal?")
        for (index, character) in currentPlayer.team.enumerated() {
            print("\(index + 1) - \(character.name) with \(character.lifePoint) PV")
        }
        guard let entry = Int(readLine()!) else {
            print("Invalid entry")
            return heal(in: currentPlayer, with: currentCharacter)
        }
        switch entry {
        case 1 ... currentPlayer.team.count:
            currentPlayer.team[entry - 1].lifePoint += currentCharacter.weapon.heal
        default:
            print("Invalid entry")
            return heal(in: currentPlayer, with: currentCharacter)
        }
    }

    //select the target player
    private func selectTargetPlayer(_ currentPlayer: Player) -> Player {
        var targetList = [Player]()
        var targetIndex = Int()

        for player in players where player.playerNumber != currentPlayer.playerNumber {
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
            return selectTargetPlayer(currentPlayer)
        }
        switch entry {
        case 1 ... targetList.count:
            targetIndex = (entry - 1)
        default:
            print("This player doesn't exist")
            return selectTargetPlayer(currentPlayer)
        }

        return targetList[targetIndex]
    }
}
