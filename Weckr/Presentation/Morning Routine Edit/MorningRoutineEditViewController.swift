//
//  MorningRoutineEditViewController.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class MorningRoutineEditViewController: UIViewController {
    
    private var editView: MorningRoutineEditView!
    private let gradient = Gradient(left: UIColor.walkthroughRedAccent.cgColor,
                                          right: UIColor.backGroundColorTransparent.cgColor)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editView = MorningRoutineEditView()
        view.addSubview(editView)
        editView.autoPinEdgesToSuperviewEdges()
        editView.button.setGradientForButton(gradient)
        
        let strings = Strings.Walkthrough.MorningRoutine.self
        editView.topLabel.setTextWithColoredPart(text: strings.title,
                                        coloredText: strings.titleColored,
                                        textColor: .white,
                                        coloredColor: UIColor.walkthroughRedAccent)
    }
}
