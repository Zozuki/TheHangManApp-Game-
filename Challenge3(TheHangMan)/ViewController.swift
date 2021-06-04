//
//  ViewController.swift
//  Challenge3(TheHangMan)
//
//  Created by MacBook Air on 25.10.2020.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var wordLabel: UILabel!
    var activatedButtons = [UIButton]()
    var words = ["THIS","IS","THE","FIRST","LOVE","ALINA"]
    var word = String()
    var letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y"]
    var wordLetters = [String]()
    var questionWord = String()
    var quesLetters = [String]()
    var letterButtons = [UIButton]()
    var LivesLabel: UILabel!
    
    var lives = 7 {
        didSet {
            LivesLabel.text = "Lives: \(lives)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGame()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        words.shuffle()
        word = words[0]
        
        for letter in word {
            let strLetter = String(letter)
            wordLetters.append(strLetter)
            questionWord.append("?")
            quesLetters.append("?")
        }
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.font = UIFont.systemFont(ofSize: 30)
        wordLabel.textAlignment = .center
        wordLabel.text = questionWord
        wordLabel.setContentHuggingPriority(UILayoutPriority(999), for: .vertical)
        view.addSubview(wordLabel)
        
       
        LivesLabel = UILabel()
        LivesLabel.translatesAutoresizingMaskIntoConstraints = false
        LivesLabel.textAlignment = .right
        LivesLabel.text = "Lives: 7"
        view.addSubview(LivesLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            LivesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            LivesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            wordLabel.topAnchor.constraint(equalTo: LivesLabel.bottomAnchor, constant: 200),
            //wordLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 120),

                      // make the clues label 60% of the width of our layout margins, minus 100
            //wordLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.9),
            wordLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            
            
            buttonsView.widthAnchor.constraint(equalToConstant: 320),
            buttonsView.heightAnchor.constraint(equalToConstant: 300),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 30),
            //buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10)
            
        ])
        
        let width = 65
        let height = 40
        
        for row in 0..<5 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                  // give the button some temporary text so we can see it on-screen
            
                letterButton.setTitle("Z", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                  // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                  // add it to the buttons view
                buttonsView.addSubview(letterButton)

                  // and also to our letterButtons array
                letterButtons.append(letterButton)
              }
          }
    }

    func loadGame() {
        for i in 0..<self.letterButtons.count {
            letterButtons[i].setTitle(letters[i], for: .normal)
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        activatedButtons.append(sender)
        sender.isHidden = true
        if wordLetters.contains(buttonTitle){
            for i in 0..<word.count {
                if wordLetters[i] == buttonTitle {
                    quesLetters[i] = buttonTitle
                }
            }
            questionWord = quesLetters.joined()
            wordLabel.text = questionWord
            if questionWord == word {
                words.remove(at: 0)
                if words.count == 0{
                    let ac = UIAlertController(title: "Congratulations!" , message: "You guessed all words!\n Your final number of remaining lives is: \(lives)" , preferredStyle: .actionSheet)
                    present(ac, animated: true)
                }
                let ac = UIAlertController(title: "You WIN, remaining lives: \(lives)", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Start new game", style: .default, handler: classicLives))
                ac.addAction(UIAlertAction(title: "Start new game with +remaining lives", style: .default, handler: plusLives))
                present(ac, animated: true)
            }
        } else {
            lives -= 1
            if lives == 0 {
                let ac = UIAlertController(title: "You lose, remaining lives: \(lives). \n The word was: '\(word)'", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Start new game", style: .destructive, handler: classicLives))
                present(ac, animated: true)
            }
        }
    }

    func plusLives(action: UIAlertAction) {
        lives = 7 + lives
        reloadView()
    }
    func classicLives(action: UIAlertAction){
        lives = 7
        reloadView()
    }
    func reloadView() {
        wordLetters.removeAll()
        questionWord.removeAll()
        quesLetters.removeAll()
        word.removeAll()
        words.shuffle()
        word = words[0]
        for letter in word {
            let strLetter = String(letter)
            wordLetters.append(strLetter)
            questionWord.append("?")
            quesLetters.append("?")
        }
        wordLabel.text = questionWord
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
}
