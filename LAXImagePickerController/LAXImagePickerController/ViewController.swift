//
//  ViewController.swift
//  LAXImagePickerController
//
//  Created by 冰凉的枷锁 on 2017/4/5.
//  Copyright © 2017年 冰凉的枷锁. All rights reserved.
//

import UIKit

class ViewController: LAXImagePickerController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        didFinishPickingBlock = { (image) in
            self.imageView.image = image
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        showImagePickerController()
    }

}

