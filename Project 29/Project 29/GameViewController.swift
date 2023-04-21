//
//  GameViewController.swift
//  Project 29
//
//  Created by Евгения Зорич on 19.04.2023.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var currentGame: GameScene!
    @IBOutlet var scoreLabelPlayer1: UILabel!
    @IBOutlet var scoreLabelPlayer2: UILabel!
    
    @IBOutlet var newGameButton: UIButton!
    var scorePlayer1 = 0 {
        didSet {
            scoreLabelPlayer1.text = "Score: \(scorePlayer1)"
        }
    }
    
    var gameStopped = false {
        didSet {
            newGameButton.isHidden = !gameStopped
        }
    }
    
    var scorePlayer2 = 0 {
        didSet {
            scoreLabelPlayer2.text = "Score: \(scorePlayer2)"
        }
    }

    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    @IBOutlet var player1Wind: UILabel!
    @IBOutlet var player2Wind: UILabel!
    var wind: Wind!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameStopped = false
        scorePlayer1 = 0
        scorePlayer2 = 0
        
        wind = Wind.getRandomWind()
        player1Wind.attributedText = wind.getText()
        player1Wind.isHidden = false
        player2Wind.isHidden = true
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        angleChanged(self)
        velocityChanged(self)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func gameControls(isHidden: Bool) {
        angleSlider.isHidden = isHidden
        angleLabel.isHidden = isHidden
        velocitySlider.isHidden = isHidden
        velocityLabel.isHidden = isHidden
        launchButton.isHidden = isHidden
    }
    
    func activatePlayer(number: Int) {
        wind = Wind.getRandomWind()
        
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
            player1Wind.attributedText = wind.getText()
            player1Wind.isHidden = false
            player2Wind.isHidden = true
        } else {
            playerNumber.text = "PLAYER TWO >>>"
            player2Wind.attributedText = wind.getText()
            player2Wind.isHidden = false
            player1Wind.isHidden = true
        }

        gameControls(isHidden: false)
    }
    
    func playerScored(player: Int) {
        if player == 1 {
            scorePlayer1 += 1
        }
        else {
            scorePlayer2 += 1
        }
        
        if scorePlayer1 == 3 {
            playerNumber.text = "PLAYER 1 WINS!!!"
            playerNumber.textColor = .red
            stopGame()
        }
        else if scorePlayer2 == 3 {
            playerNumber.text = "PLAYER 2 WINS!!!"
            playerNumber.textColor = .red
            stopGame()
        }
    }
    
    func stopGame() {
        gameControls(isHidden: true)
        gameStopped = true
    }
    
    
    @IBAction func newGame(_ sender: Any) {
        gameStopped = false
        scorePlayer2 = 0
        scorePlayer1 = 0
        currentGame?.newGame()
    }
}
