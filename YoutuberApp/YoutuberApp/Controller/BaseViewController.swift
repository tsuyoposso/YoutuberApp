//
//  ViewController.swift
//  YoutuberApp
//
//  Created by 長坂豪士 on 2019/10/22.
//  Copyright © 2019 NagaKe. All rights reserved.
//

import UIKit
import SegementSlide

class BaseViewController: SegementSlideViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        scrollToSlide(at: 0, animated: true)
        
        
        // Do any additional setup after loading the view.
    }

    override var headerView: UIView? {
        
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleToFill
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerHeight: CGFloat
        if #available(iOS 11.0, *) {
            headerHeight = view.frame.height/4 + view.safeAreaInsets.top
        } else {
            headerHeight = view.frame.height/4 + topLayoutGuide.length
        }
        // true -> false にすると、headerが全画面になる
        headerView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
        return headerView
        
    }
    
    override var titlesInSwitcher: [String] {
        
        return ["那須川天心", "おもしろ", "犬", "ニュース", "ヒカキン", "猫"]
    }
    
    
    
    
}

