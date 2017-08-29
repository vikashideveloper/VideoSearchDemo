//
//  VideoPlayerVC.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 29/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class VideoPlayerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back_btnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
