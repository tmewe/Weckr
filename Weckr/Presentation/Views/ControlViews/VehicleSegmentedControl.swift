//
//  SegmentedControl.swift
//  Weckr
//
//  Created by admin on 16.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import UIKit

class VehicleSegmentedControl:UIControl {
    private var labels = [UILabel]()
    var thumbView = UIView()
    
    var items:[String] = ["item1","item2","item3"]{
        didSet{
            setupLabels()
        }
    }
    
    var selectedIndex : Int = 0 {
        didSet{
            displayNewSelectedIndex()
        }
    }
    
    init(items: [String]) {
        super.init(frame: CGRect.zero)
        self.items = items
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor.walkthroughOrangeAccent.cgColor
        layer.borderWidth = 2
        backgroundColor = UIColor.clear
        setupLabels()
        insertSubview(thumbView, at: 0)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var selectedFrame = self.bounds
        let newWith = selectedFrame.width / CGFloat(items.count)
        selectedFrame.size.width = newWith
        layer.cornerRadius = frame.height / 2
        thumbView.frame = selectedFrame
        thumbView.backgroundColor = .walkthroughOrangeAccent
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        
        for index in 0...labels.count - 1 {
            let label = labels[index]
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRect(x: xPosition,y: 0,width: labelWidth,height: labelHeight)
            
        }
        
        
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex: Int?
        for(index, item) in labels.enumerated()  {
            if item.frame.contains(location){
            calculatedIndex = index
            }
        }
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for:.valueChanged)
        }
        return false
    }
    
    func displayNewSelectedIndex(){
        let label = labels[selectedIndex]
        self.thumbView.frame = label.frame
    }
    func setupLabels(){
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll(keepingCapacity: true)
        for index in 1...items.count{
        let label = UILabel(frame: CGRect.zero)
        label.text = items[index - 1]
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        self.addSubview(label)
        labels.append(label)
        }
    
    }
    
    
}
