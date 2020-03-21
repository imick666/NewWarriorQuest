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
                let currentCharacter = currentPlayer.selectCharacter()
                //show wich character have been choose
                print("You choosed \(currentCharacter.name)")
                //ask wich action to do
                currentCharacter.actions(for: currentPlayer, to: players)
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
}
