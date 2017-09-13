//
//  ViewController.swift
//  Colores
//
//  Created by Alan Casas on 22/8/17.
//  Copyright © 2017 Alan Casas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var imageKnobBase: UIImageView!
    @IBOutlet weak var imageKnob: UIImageView!
    
    var deltaAngle: CGFloat?
    var startTransform:CGAffineTransform?

    //Punto de partida de angulo
    var setPointAngle = Double.pi/2
    
    var maxAngle = 7 * Double.pi / 6
    
    var minimunAngle = 0 - (Double.pi / 6)
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageKnob.isHidden = true
        imageKnobBase.isHidden = true
        imageKnob.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Se puede hacer de ambas maneras
        switchButton.setImage(#imageLiteral(resourceName: "img_switch_off") , for: .normal)
        switchButton.setImage(UIImage(named:"img_switch_on"), for: .selected)
    }

    @IBAction func switchButtonPressed(_ sender: UIButton) {
    
        switchButton.isSelected = !switchButton.isSelected
        
        if switchButton.isSelected{
            imageKnob.isHidden = false
            imageKnobBase.isHidden = false
            resetKnob()
        }else{
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0, brightness: 0.2, alpha: 1.0)
            imageKnob.isHidden = true
            imageKnobBase.isHidden = true
        }
        
    }
    
    func resetKnob(){
        view.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 0.75, alpha: 1.0)
        imageKnob.transform = CGAffineTransform.identity
        setPointAngle = Double.pi/2
    }
    
    func touchIsInKnobWithDistance(distance:CGFloat) -> Bool {
        if distance > (imageKnob.bounds.height / 2) {
            return false
        }
        return true
    }
    
    func calculateDistanceFromCenter (_ point: CGPoint) -> CGFloat{
        
        let center = CGPoint(x: imageKnob.bounds.size.width / 2, y: imageKnob.bounds.size.height / 2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        
        return sqrt((dx*dy) + (dx*dy))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let delta = touch.location(in: imageKnob)
            let distance = calculateDistanceFromCenter(delta)
            
            if touchIsInKnobWithDistance(distance: distance){
                startTransform = imageKnob.transform
                let center = CGPoint(x: imageKnob.bounds.size.width / 2, y: imageKnob.bounds.size.height / 2)
                let deltaX = delta.x - center.x
                let deltaY = delta.y - center.y
            
                deltaAngle = atan2(deltaY, deltaX)
            
            }
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            if touch.view == imageKnob {
                deltaAngle = nil
                startTransform = nil
            }
        }
        
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first,
            let deltaAngle = deltaAngle,
            let startTransform = startTransform,
            touch.view == imageKnob{
            
            let position = touch.location(in: imageKnob)
            let distance = calculateDistanceFromCenter(position)
            
            if touchIsInKnobWithDistance(distance: distance){
                
                let center  = CGPoint(x: imageKnob.bounds.size.width / 2, y: imageKnob.bounds.size.height / 2)
                let deltaX = position.x - center.x
                let deltaY = position.y - center.y
                let angle = atan2(deltaY, deltaX)
                
                let angleDif = deltaAngle - angle
                let newTransform = startTransform.rotated(by: -angleDif)
                let lastSetPointAngle = setPointAngle
                
                setPointAngle = setPointAngle + Double(angleDif)
                if setPointAngle >= minimunAngle && setPointAngle <= maxAngle{
                    view.backgroundColor = UIColor(hue: colorValueFromAngle(angle: setPointAngle), saturation: 0.75, brightness: 0.75, alpha: 1)
                    imageKnob.transform = newTransform
                    self.startTransform = newTransform
                }else{
                    setPointAngle = lastSetPointAngle
                }

            }

        }
        
        super.touchesMoved(touches, with: event)
        
    }
 
    func colorValueFromAngle(angle: Double) -> CGFloat {
        
        let hueValue  = (angle - minimunAngle) * (360 / (maxAngle - minimunAngle))
        
        return CGFloat(hueValue / 360)
    }
    
}




























