//
//  NuevoBancoViewController.swift
//  Psei
//
//  Created by Carlos Martínez on 28/01/2019.
//  Copyright © 2019 Carlos Martínez. All rights reserved.
//

import UIKit

class NuevoBancoViewController: UIViewController {

	var banco: Banco = Banco()
	
	
	@IBOutlet weak var codigoText: UITextField!
	
	@IBOutlet weak var NombreText: UITextField!
	@IBOutlet weak var DireccionText: UITextField!
	@IBOutlet weak var mostrarSwitch: UISwitch!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Nuevo Banco"
		self.navigationItem.backBarButtonItem?.title = "Volver"
		
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
