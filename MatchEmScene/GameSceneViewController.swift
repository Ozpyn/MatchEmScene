//
//  ViewController.swift
//  MatchEmScene
//
//  Created by ozpyn on 9/18/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var btns: [UIButton] = []
    
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
    
    var time = 12.0 {
        didSet {
            self.infoLabel.text = labelText(self.time, self.score, self.recCount)
        }
    }
    
    var labelText: (Double, Int, Int) -> String = { time, score, count in
        return "Time: \(Int(time)) - Score: \(score) - Total Count: \(count)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoLabel.text = labelText(self.time, self.score, self.recCount)
        
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.time > 0 {
                self.time -= 1
                self.createRandomRectanglePair()
            } else {
                timer.invalidate()
            }
        }
    }
    
    func startGame() {
        // Implement game start logic if needed
    }
    
    func createRandomRectangle() {
        let minSize: CGFloat = 50.0
        let maxSize: CGFloat = 200.0
        
        let width = CGFloat.random(in: minSize...maxSize)
        let height = CGFloat.random(in: minSize...maxSize)
        
        let x = CGFloat.random(in: 0...(self.view.frame.width - width))
        let y = CGFloat.random(in: self.view.safeAreaInsets.top...(self.view.frame.height - height - self.view.safeAreaInsets.bottom))
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let rectBtn = UIButton(frame: frame)
        
        rectBtn.backgroundColor = UIColor(red: CGFloat.random(in: 0...1.0), green: CGFloat.random(in: 0...1.0), blue: CGFloat.random(in: 0...1.0), alpha: 1.0)
        
        let randomChar = String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
        rectBtn.setTitle(randomChar, for: .normal)
        rectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 30) // Adjust font size as needed
        rectBtn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        self.btns.append(rectBtn)
        self.view.addSubview(rectBtn) // Fixed typo from addSubView to addSubview
        
        self.recCount += 1
    }
    
    func createRandomRectanglePair() {
        let minSize: CGFloat = 50.0
        let maxSize: CGFloat = 200.0
        
        let width = CGFloat.random(in: minSize...maxSize)
        let height = CGFloat.random(in: minSize...maxSize)
        
        let randomChar = String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
        
        let color = UIColor(red: CGFloat.random(in: 0...1.0), green: CGFloat.random(in: 0...1.0), blue: CGFloat.random(in: 0...1.0), alpha: 1.0)
        
        let x1 = CGFloat.random(in: 0...(self.view.frame.width - width))
        let y1 = CGFloat.random(in: self.view.safeAreaInsets.top...(self.view.frame.height - height - self.view.safeAreaInsets.bottom))
        
        let x2 = CGFloat.random(in: 0...(self.view.frame.width - width))
        let y2 = CGFloat.random(in: self.view.safeAreaInsets.top...(self.view.frame.height - height - self.view.safeAreaInsets.bottom))
        
        let frame1 = CGRect(x: x1, y: y1, width: width, height: height)
        let rectBtn1 = UIButton(frame: frame1)
        
        let frame2 = CGRect(x: x2, y: y2, width: width, height: height)
        let rectBtn2 = UIButton(frame: frame2)
        
        rectBtn1.backgroundColor = color
        rectBtn1.setTitle(randomChar, for: .normal)
        rectBtn1.titleLabel?.font = UIFont.systemFont(ofSize: 30) // Adjust font size as needed
        rectBtn1.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        rectBtn2.backgroundColor = color
        rectBtn2.setTitle(randomChar, for: .normal)
        rectBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 30) // Adjust font size as needed
        rectBtn2.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        self.btns.append(rectBtn1)
        self.view.addSubview(rectBtn1) // Fixed typo from addSubView to addSubview
        
        self.btns.append(rectBtn2)
        self.view.addSubview(rectBtn2) // Fixed typo from addSubView to addSubview
        
        self.recCount += 2
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        guard let titleChar = sender.titleLabel?.text, self.time > 0 else { return }
        
        // Optional: Handle specific actions based on button tapped if necessary
        
        self.btns.removeAll { btn in
            btn == sender
        }
        sender.removeFromSuperview()
        self.score += 1 // Fixed typo from 1s to 1
    }
}
