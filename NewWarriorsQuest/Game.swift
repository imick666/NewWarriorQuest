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
        }

        score.players = players
        showTeams()
        print("\n---FIGHT---\n")
        //--------------------------
        // MARK: FIGHT
        //--------------------------
        state = .ongoing
        repeat {
            //count rounds
            score.round += 1
            //show round number
            print("ROUND \(score.round)")
            //switch on each player to each round
            for currentPlayer in players where currentPlayer.state == .alive {
                //print the current player
                print("Player \(currentPlayer.playerNumber) : \(currentPlayer.nickname) ")
                // ternary condition for make apears random weapon with 25% of chance
                _ = Int.random(in: 0 ... 100) <= 25 ? randomWeaponAppear(for: currentPlayer) : nil
                //select the current character
                let currentCharacter = selectCharacter(currentPlayer)
                //show wich character have been choose
                print("You choosed \(currentCharacter.name)")
                //ask wich action to do
                actions(for: currentPlayer, with: currentCharacter)
                //check if characters are dead or if the game is over and switch player
                checkState(currentPlayer)
                guard players.count > 1 else {
                    state = .over
                    break
                }
                showTeams()
            }
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
        for player in players {
            for character in player.team where character.lifePoint <= 0 {
                character.state = .dead
            }
            var checkIfPlayerDead = 0
            for character in player.team where character.state == .alive {
                checkIfPlayerDead += 1
            }
            if checkIfPlayerDead == 0 {
                player.state = .dead
            }
        }
    }
     //create a random weapon
    private func randomWeaponAppear(for currentPlayer: Player) {
        let randomWeapon = RandomWeapon(name: "", attack: 0, heal: 0)

        print("""
            A new weapon has appear!!!!
            Do you wanna assign \(randomWeapon.name) to a character?
            Y / N
        """)
        if let entry = readLine() {
            switch entry {
            case "y", "Y":
                assignWeapon(randomWeapon, to: currentPlayer)
            case "n", "N":
                print("As you want, the weapon is destroy")
            default:
                print("Invalid entry")
                return randomWeaponAppear(for: currentPlayer)
            }
        }
    }

    //Assign the random weapon to an alive character
    private func assignWeapon(_ randomWeapon: Weapon, to currentPlayer: Player) {
        var currentAliveCharacter = [Character]()

        for character in currentPlayer.team where character.state == .alive {
            currentAliveCharacter.append(character)
        }

        print("Wich character will use this weapon?")
        for (index, character) in currentAliveCharacter.enumerated() {
            print("\(index + 1) - \(character.name) with \(character.weapon.attack)"
                + "Attack and \(character.weapon.heal) Heal capacity")
        }
        guard let entry = Int(readLine()!) else {
            print("Invalid entry")
            return assignWeapon(randomWeapon, to: currentPlayer)
        }
        switch entry {
        case 1 ... currentAliveCharacter.count:
            currentAliveCharacter[entry - 1].weapon = randomWeapon
            print("Character \(currentAliveCharacter[entry - 1].name) have now \(randomWeapon.attack)"
                + "of attack and \(randomWeapon.heal) of heal capacity!")
        default:
            print("This character doesn't exist.")
            return assignWeapon(randomWeapon, to: currentPlayer)
        }
    }

    //select character to use
    private func selectCharacter(_ currentPlayer: Player) -> Character {
        var aliveCharacter = [Character]()

        for character in currentPlayer.team where character.state == .alive {
            aliveCharacter.append(character)
        }
        print("Select your character :")
        for (index, character) in aliveCharacter.enumerated() {
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
        case 1 ... aliveCharacter.count:
            return aliveCharacter[entry - 1]
        default:
            print("This character doesn't exist")
            return selectCharacter(currentPlayer)
        }
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
            return attack(from: currentPlayer, with: currentCharacter)
        }

        switch entry {
        case 1 ... targetPlayer.team.count:
            targetAliveCharacter[entry - 1].lifePoint -= currentCharacter.weapon.attack
            for character in  targetAliveCharacter where character.lifePoint < 0 {
                character.lifePoint = 0
            }
        default:
            print("Invalid entry")
            return attack(from: currentPlayer, with: currentCharacter)
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
    private func selectTargetPlayer(_ currentPlayer: Player) -> Player {
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
