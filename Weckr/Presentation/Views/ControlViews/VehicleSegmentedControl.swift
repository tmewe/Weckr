//
//  SegmentedControl.swift
//  Weckr
//
//  Created by admin on 16.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//


import UIKit

class VehicleSegmentedControl:UIControl {
    
    private var imageViewList = [UIImageView]()
    private var thumbView = UIView()
    
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    private var items: [String] = [] {
        didSet {
            setupImageView()
        }
    }
    
    private let gradient = Gradient(left: UIColor.walkthroughOrangeAccent.cgColor,
                                    right: UIColor.backGroundColorTransparent.cgColor)
    
    var selectedLabelColor : UIColor = UIColor.walkthroughOrangeAccent
    var unselectedLabelColor : UIColor = UIColor.white
    
    
    var font : UIFont! = UIFont.systemFont(ofSize: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    convenience init(selected: Int = 0, imageNames: String...) {
        self.init();
        self.items = imageNames
        self.selectedIndex = selected;
        setupView()
    }
    
    func setupView(){
        layer.masksToBounds = true
        //TODO: Why don't gradients work?
        self.layer.backgroundColor = UIColor.segmentedControlBackground.cgColor
        
        setupImageView()
        addIndividualItemConstraints(items: imageViewList, mainView: self, padding: 0)
        
        insertSubview(thumbView, at: 0)
    }
    
    func setupImageView(){
        guard items.count > 0 else { return }
        
        for label in imageViewList {
            label.removeFromSuperview()
        }
        
        imageViewList.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            let imageView = UIImageView.newAutoLayout()
            self.addSubview(imageView)
            
            imageView.contentMode = .center
            imageView.image = UIImage(named: items[index - 1])?.withRenderingMode(.alwaysTemplate)
            imageView.backgroundColor = UIColor.clear
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageViewList.append(imageView)
        }
        
        addIndividualItemConstraints(items: imageViewList, mainView: self, padding: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2.0
        var selectFrame = self.bounds
        
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        
        thumbView.frame = selectFrame
        thumbView.setGradientForButton(gradient)
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        displayNewSelectedIndex()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        var calculatedIndex : Int?
        for (index, item) in imageViewList.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex(){
        guard selectedIndex < imageViewList.count else { return }

        for (_, item) in imageViewList.enumerated() {
            item.layer.masksToBounds = true
            item.layer.borderColor = unselectedLabelColor.cgColor
            item.tintColor = UIColor.segmentedControlUnselectedTint
            
        }
        
        let imageView = imageViewList[selectedIndex]
        imageView.layer.borderColor = selectedLabelColor.cgColor
        imageView.tintColor = UIColor.white
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping:  0.8,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseIn,
                       animations: {
            self.thumbView.frame = imageView.frame
            
        }, completion: nil)
    }
    
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        for (index, button) in items.enumerated() {
            let isLast = index == items.count - 1
            let isFirst = index == 0
            

            let widthConstraint = NSLayoutConstraint(item: button,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: items.first,
                                                     attribute: .width,
                                                     multiplier: 1.0  ,
                                                     constant: 0)
            
            let topConstraint = NSLayoutConstraint(item: button,
                                                   attribute: .top,
                                                   relatedBy:.equal,
                                                   toItem: mainView,
                                                   attribute: .top,
                                                   multiplier: 1.0,
                                                   constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: mainView,
                                                      attribute: .bottom,
                                                      multiplier: 1.0,
                                                      constant: 0)
            
            
            
            let leftConstraint = isFirst
                ? NSLayoutConstraint(item: button,
                                     attribute: .left,
                                     relatedBy:  .equal,
                                     toItem: mainView,
                                     attribute: .left,
                                     multiplier: 1.0,
                                     constant: padding)
                : NSLayoutConstraint(item: button,
                                     attribute: .left,
                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                     toItem: items[index-1],
                                     attribute: .right,
                                     multiplier: 1.0,
                                     constant: padding)
            
            let rightConstraint = isLast
                ? NSLayoutConstraint(item: button,
                                     attribute: .right,
                                     relatedBy: .equal,
                                     toItem: mainView,
                                     attribute: .right,
                                     multiplier: 1.0,
                                     constant: -padding)
                : NSLayoutConstraint(item: button,
                                     attribute: .right,
                                     relatedBy: .equal,
                                     toItem: items[index+1],
                                     attribute: .left,
                                     multiplier: 1.0,
                                     constant: -padding)

            mainView.addConstraints([widthConstraint,
                                     topConstraint,
                                     bottomConstraint,
                                     leftConstraint,
                                     rightConstraint])
        }
    }
    
}

