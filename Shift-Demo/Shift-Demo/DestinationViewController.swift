//
//  DestinationViewController.swift
//  Shift-Demo
//
//  Created by Matthew Buckley on 12/10/15.
//  Copyright © 2015 Raizlabs. All rights reserved.
//

import UIKit

class DestinationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func didTap(sender: UITapGestureRecognizer) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
