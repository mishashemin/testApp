//
//  ViewController.swift
//  testApp
//
//  Created by  misha shemin on 23/01/2020.
//  Copyright © 2020 mishashemin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newMVC = segue.destination as? SearchViewController {
            if segue.identifier == "threePerson"{
                newMVC.searchType = .group
            }
            else if segue.identifier == "onePerson"{
                newMVC.searchType = .user
            }
        }
        
    }

    
}

