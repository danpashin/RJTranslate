//
//  TickView.swift
//  RJTranslate-App
//
//  Created by Даниил on 16/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class TickView : UIView {
    
    @IBInspectable
    var isEnabled: Bool {
        get { return self._isEnabled }
        
        set {
            self.setEnabled(newValue, animated: false)
        }
    }
    
    private var _isEnabled = false
    
    override static var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override var layer: CAShapeLayer {
        return super.layer as! CAShapeLayer
    }
    
    override init(frame: CGRect) {
        let maxSide = MAX(a: frame.width, b: frame.height)
        
        var newFrame = frame
        newFrame.size = CGSize(width: maxSide, height: maxSide / 2.0)
        
        super.init(frame: newFrame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    private func commonInit() {
        self.layer.strokeColor = ColorScheme.default.accentSecondary.cgColor
        self.layer.fillColor = UIColor.clear.cgColor
        self.layer.strokeEnd = 0.0
        self.layer.lineWidth = 2.0
        self.layer.lineCap = .round
        
        let selfRect = self.bounds
        let mutableTickPath = CGMutablePath()
        mutableTickPath.move(to: CGPoint(x: selfRect.maxX / 4.0, y: selfRect.midY))
        mutableTickPath.addLine(to: CGPoint(x: selfRect.midX, y: selfRect.maxY - 1.0))
        mutableTickPath.addLine(to: CGPoint(x: selfRect.maxX - selfRect.midX / 4.0, y: selfRect.minY + 1.0))
        
        self.layer.path = mutableTickPath
    }
    
    func setEnabled(_ enabled: Bool, animated: Bool) {
        if animated {
            let tickAnimation = CABasicAnimation(keyPath: "strokeEnd")
            tickAnimation.fromValue = self._isEnabled ? 1.0 : 0.0
            tickAnimation.toValue = enabled ? 1.0 : 0.0
            tickAnimation.duration = 0.2
            tickAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            self.layer.add(tickAnimation, forKey: "strokeEndAnimation")
            self.layer.strokeEnd = enabled ? 1.0 : 0.0
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.layer.strokeEnd = enabled ? 1.0 : 0.0
            CATransaction.commit()
        }
        
        self._isEnabled = enabled
    }
}
