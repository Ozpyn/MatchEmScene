//
//  GameSceneViewController.swift
//  MatchEmScene
//
//  Created by ozpyn on 9/18/24.
//

import UIKit

class GameSceneViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var buttonPairs: [String: [UIButton]] = [:]
    var btns: [UIButton] = []
    var firstButton: UIButton?
    
    var score = 0 {
        didSet {
            self.infoLabel.text = labelText(self.time, self.score, self.recCount)
        }
    }
    
    var recCount = 0 {
        didSet {
            self.infoLabel.text = labelText(self.time, self.score, self.recCount)
        }
    }
    
    var time = 24.0 {
        didSet {
            self.infoLabel.text = labelText(self.time, self.score, self.recCount)
        }
    }
    
    var labelText: (Double, Int, Int) -> String = { time, score, count in
        return "Time: \(Int(time)) - Score: \(score) - Total Count: \(count)"
    }
    
    let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoLabel.text = labelText(self.time, self.score, self.recCount)
        
        setupStartButton()
    }
    
    func setupStartButton() {
        startButton.setTitle("Start Game", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        startButton.frame = CGRect(x: (self.view.frame.width - 200) / 2, y: (self.view.frame.height - 50) / 2, width: 200, height: 50)
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        self.view.addSubview(startButton)
    }
    
    @objc func startGame() {
        startButton.isHidden = true // Hide start button
        infoLabel.isHidden = false
        countdown(from: 3)
    }
    
    func countdown(from seconds: Int) {
        var remainingTime = seconds + 1
        let countdownLabel = UILabel(frame: CGRect(x: (self.view.frame.width - 100) / 2, y: (self.view.frame.height - 100) / 2, width: 100, height: 100))
        countdownLabel.font = UIFont.systemFont(ofSize: 60)
        countdownLabel.textAlignment = .center
        self.view.addSubview(countdownLabel)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if remainingTime > 0 {
                if remainingTime == 1 {
                    countdownLabel.text = "Go!"
                } else {
                    countdownLabel.text = "\(remainingTime - 1)"
                }
                remainingTime -= 1
            } else {
                timer.invalidate()
                self.startGameTimer()
                countdownLabel.removeFromSuperview()
            }
        }
    }
    
    func startGameTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.time > 0 {
                self.time -= 1
                self.createRandomRectangleSet()
            } else {
                timer.invalidate()
                self.endGame()
            }
        }
    }
    
    func endGame() {
        // Handle end of game logic here (e.g., show final score)
        infoLabel.text = "Game Over! Final Score: \(score)"
        // Optionally show a restart button
    }
    
    func createRandomRectangleSet() {
        let minSize: CGFloat = 50.0
        let maxSize: CGFloat = 200.0
        
        let width = CGFloat.random(in: minSize...maxSize)
        let height = CGFloat.random(in: minSize...maxSize)
        
        let randomChar = String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
        let color = UIColor(red: CGFloat.random(in: 0...1.0), green: CGFloat.random(in: 0...1.0), blue: CGFloat.random(in: 0...1.0), alpha: 1.0)
        
        let cornerRadius = min(width, height) / 3
        
        let maxY = (self.view.frame.maxY - self.view.safeAreaInsets.bottom - infoLabel.frame.height - height)
        
        for _ in 0...1 {
            let x = CGFloat.random(in: 0...self.view.frame.maxX - width)
            let y = CGFloat.random(in: self.view.safeAreaInsets.top...maxY)

            let frame = CGRect(x: x, y: y, width: width, height: height)
            let rectBtn = UIButton(frame: frame)
            
            rectBtn.backgroundColor = color
            rectBtn.setTitle(randomChar, for: .normal)
            rectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            rectBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            
            rectBtn.layer.cornerRadius = cornerRadius
            rectBtn.clipsToBounds = true
            
            self.btns.append(rectBtn)
            self.view.addSubview(rectBtn)
            
            buttonPairs[randomChar, default: []].append(rectBtn)
            
            self.recCount += 1
        }
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        guard self.time > 0 else { return }
        
        if firstButton == nil {
            // First button tapped
            firstButton = sender
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // Slightly enlarge
        } else {
            // Second button tapped
            if let title = sender.title(for: .normal), let pair = buttonPairs[title] {
                if sender.transform == CGAffineTransform(scaleX: 1.1, y: 1.1) {
                    // If the second button is already highlighted, unhighlight it
                    sender.transform = .identity // Reset scale
                    firstButton?.transform = .identity // Reset scale
                    firstButton = nil // Reset
                } else if pair.contains(firstButton!) {
                    // Remove buttons with animation
                    animateButtonRemoval(firstButton!)
                    animateButtonRemoval(sender)
                    
                    self.btns.removeAll { $0 == firstButton || $0 == sender }
                    buttonPairs[title] = nil
                    self.score += 1
                } else {
                    // No match
                    firstButton?.transform = .identity // Reset scale
                }
            }
            firstButton = nil // Reset for the next pair
        }
    }

    private func animateButtonRemoval(_ button: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1) // Shrink
            button.alpha = 0.0 // Fade out
        }) { _ in
            button.removeFromSuperview() // Remove after animation completes
        }
    }
}
