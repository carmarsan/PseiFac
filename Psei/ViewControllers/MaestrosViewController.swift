//
//  SecondViewController.swift
//  Psei
//
//  Created by Carlos Martínez on 28/01/2019.
//  Copyright © 2019 Carlos Martínez. All rights reserved.
//

import UIKit

class MaestrosViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Si queremos que los títulos del navigationBar sean grandes (true) o pequeños (false = por defecto)
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
			
		} else {
			// Fallback on earlier versions
		}
		
		
	}


}

