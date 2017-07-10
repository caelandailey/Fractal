//
//  ViewController.swift
//  Fractal
//
//  Created by Caelan Dailey on 7/9/17.
//  Copyright © 2017 Caelan Dailey. All rights reserved.
//


import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        if let url = Bundle.main.url(forResource: file, withExtension: "sks") {
            do {
                let sceneData = try Data(contentsOf: url)
                let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
                
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
                archiver.finishDecoding()
                return scene
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, UIScrollViewDelegate {
    
    var node:SKSpriteNode!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .fill
            
            node = scene.childNode(withName: "fractal") as! SKSpriteNode
            
            skView.presentScene(scene)
            
        }
        
        updateShader(scrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateShader(scrollView)
    }
    
    func updateShader(_ scrollView: UIScrollView) {
        let zoomUniform = node.shader!.uniformNamed("zoom")!
        
        let offsetUniform = node.shader!.uniformNamed("offset")!
        
        var offset = scrollView.contentOffset
        
        offset.x /= scrollView.contentSize.width
        offset.y /= scrollView.contentSize.height
        
        zoomUniform.floatValue = Float(scrollView.zoomScale)
        offsetUniform.floatVector2Value = GLKVector2Make(Float(offset.x), Float(offset.y))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateShader(scrollView)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateShader(scrollView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
