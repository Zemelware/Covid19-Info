//
//  InfoViewController.swift
//  Covid19 Info
//
//  Created by Ethan Zemelman on 2020-08-17.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var feverView: UIView!
    @IBOutlet weak var coughView: UIView!
    @IBOutlet weak var tirednessView: UIView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var cleanHandsView: UIView!
    @IBOutlet weak var physicallyDistanceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in [feverView, coughView, tirednessView, maskView, cleanHandsView, physicallyDistanceView] {
            view?.layer.cornerRadius = 15
            view?.layer.shadowOffset = CGSize(width: 0, height: 2)
            view?.layer.shadowRadius = 0.8
            view?.layer.shadowOpacity = 0.3
            view?.layer.masksToBounds = false
        }
    }
    
}
