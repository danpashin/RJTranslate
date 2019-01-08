//
//  TouchResponsiveCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 07/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public enum AppCellState {
    case normal
    case pressed
    
    var asString: String {
        switch self {
        case .pressed:
            return "Pressed"
            
        case .normal:
            return "Normal"
        }
    }
}

public class TouchResponsiveCollectionCell: UICollectionViewCell {
    
    public private(set) var state: AppCellState = .normal
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.updateState(.normal, animated: false)
    }
    
    private func updateState(_ state: AppCellState, animated: Bool = true) {
        if self.state != state {
            self.state = state
            
            let scaleTransformCoefficient = CGFloat((state == .pressed) ? 0.95 : 1.0)
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.15, delay: 0.0, options: [.allowAnimatedContent, .allowAnimatedContent], animations: { 
                    self.transform = CGAffineTransform(scaleX: scaleTransformCoefficient, y: scaleTransformCoefficient)
                })
            }
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.updateState(.pressed)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { 
            self.updateState(.normal)
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.updateState(.normal)
    }
}
