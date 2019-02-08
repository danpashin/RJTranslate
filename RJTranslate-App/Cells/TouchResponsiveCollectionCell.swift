//
//  TouchResponsiveCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 07/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class TouchResponsiveCollectionCell: UICollectionViewCell {
    
    enum State {
        case normal
        case pressed
    }
    
    
    private(set) var currentState: State = .normal
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.setState(.normal, animated: false)
    }
    
    private func setState(_ state: State, animated: Bool = true) {
        if self.currentState != state {
            self.currentState = state
            
            let scaleRatio: CGFloat = (state == .pressed) ? 0.95 : 1.0
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.15, delay: 0.0, options: [.allowAnimatedContent, .allowAnimatedContent], animations: {
                    self.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.setState(.pressed)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.setState(.normal)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.setState(.normal)
    }
}
