//
//  Consentration.swift
//  Consentration
//
//  Created by Алексей on 26/05/2019.
//  Copyright © 2019 Алексей. All rights reserved.
//

import Foundation

class Concentraion {
    
    var cards = [Card]()
    var faceUpCard: Int?
    var incScore = 0
    var idFactory: Int = 0
    
    func getUniqueId() -> Int {
        idFactory += 1
        return idFactory
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards{
            var card = Card()
            card.id = getUniqueId()
            cards+=[card, card]
        }
        for _ in 0...30{
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            let cup = cards.remove(at: randomIndex)
            cards.append(cup)
        }
        
    }
    
    
    
    func choseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = faceUpCard, matchIndex != index{
                if !cards[index].isChoosen {
                    cards[index].isChoosen = true
                } else {
                    incScore += -1
                }
                
                if !cards[matchIndex].isChoosen {
                    cards[index].isChoosen = true
                } else {
                    incScore += -1
                }
                if cards[matchIndex].id == cards[index].id{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    incScore = 2
                }
                cards[index].isFaceUp = true
                faceUpCard = nil
            } else {
                for flipDownIndex in cards.indices{
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                faceUpCard = index
            }
        }
    }
    
    
    
}
