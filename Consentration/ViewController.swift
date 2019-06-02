//
//  ViewController.swift
//  Consentration
//
//  Created by Алексей on 26/05/2019.
//  Copyright © 2019 Алексей. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentraion(numberOfPairsOfCards: (cardButtons.count + 1) / 2)

    var flipCount = 0 {
        didSet{
            flipCountLabel.text = "Число нажатий: \(flipCount)"
        }
    }
    
    @IBOutlet weak var goTime: UILabel!
    
    @IBOutlet weak var gameTime: UILabel!
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Счет: \(score)"
        }
    }
    
    var gameTimeCount = 0 {
        didSet{
            gameTime.text = "Время игры: \(gameTimeCount)"
        }
    }
    
    var stepTimeCount = 0 {
        didSet{
            goTime.text = "Время хода: \(stepTimeCount)"
        }
    }
    
    var timer = Timer()
    
    var stepTimer = Timer()
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    var emojiChoices = [String]()
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var themes = [
        ["😀","😃","😗","😙","😒","😏","😫", "😩"],
        ["🐵","🙈","🙉","🙊","🐒","🐻","🐨", "🐼"],
        ["🐙","🦑","🦐","🦀","🐡","🐠","🐟", "🐬"],
        ["🎄","🌲","🌳","🌴","🌱","🌿","☘️", "🍀"],
        ["🌔","🌓","🌒","🌑","🌘","🌗","🌖", "🌕"],
        ["🏊‍♀️","🏊‍♂️","🤼‍♀️","🤼‍♂️","⛹️‍♀️","⛹️‍♂️","🏌️‍♀️", "🏌️‍♂️"],
    ]
    
    var flag = 1
    
    var emoji = [Int:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newGame()
    }
    
    
    @objc func timerAction() {
        gameTimeCount+=1
    }
    
    
    @objc func stepTimerAction() {
        stepTimeCount+=1
    }
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let index = self.cardButtons.index(of: sender) {
            stepTimer.invalidate()
            stepTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(stepTimerAction), userInfo: nil, repeats: true)
            if flag == 0 {
                flag = 1
                stepTimer.invalidate()
                stepTimeCount = 0
            } else {
                flag = 0
            }
            game.choseCard(at: index)
            score += game.incScore
            game.incScore = 0
            updateViewFromModel()
        } else{
            print("Button not in array!")
        }
    }
    
    
    @IBAction func beginNewGame(_ sender: UIButton) {
        self.newGame()
    }
    
    
    func newGame() {
        flipCount = 0
        score = 0
        emoji.removeAll()
        emojiChoices = themes[Int(arc4random_uniform(UInt32(themes.count)))]
        game = Concentraion(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        gameTimeCount = 0
        stepTimeCount = 0
        updateViewFromModel()
    }
    
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            } else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) :#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
            }
        }
    }
    

    func emoji(for card: Card) -> String {
        if emoji[card.id] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.id] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.id] ?? "?"
    }
}

