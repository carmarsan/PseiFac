//
//  NuevoBancoViewController.swift
//  Psei
//
//  Created by Carlos Martínez on 28/01/2019.
//  Copyright © 2019 Carlos Martínez. All rights reserved.
//

import UIKit

class ModificarBancoViewController: UIViewController {

	var banco: Banco = Banco()
	
	@IBOutlet weak var codigoText: UITextField!
	@IBOutlet weak var NombreText: UITextField!
	@IBOutlet weak var DireccionText: UITextField!
	@IBOutlet weak var mostrarSwitch: UISwitch!
	
	@IBOutlet weak var btnSave: UIBarButtonItem!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		codigoText.isEnabled = false

		// Si queremos poner un botón e el navigationItem
		// Ponemos un botón en la parte derecha de la barra de navegación
//		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .plain, target: self	, action: nil)
//		// Para dar un título a la barra de navegación del Controller
//		navigationItem.title = "Modificar Banco"

		codigoText.text = banco.Codigo
		NombreText.text = banco.Nombre
		DireccionText.text = banco.Direccion
		mostrarSwitch.isOn = banco.Mostrar
		
    }
	
	// Cuando damos a guardar
	@IBAction func btnSaveClick(_ sender: Any) {
		
		let bank: Banco = Banco(Id: banco.BancoId, Codigo: codigoText.text!, Nombre: NombreText.text!, Direccion: DireccionText.text!, Mostrar: mostrarSwitch.isOn, FechaAlta: banco.FechaAlta)
		
		Banco.Save(banco : bank) { (error) in
			if let error = error {
				fatalError(error.localizedDescription)
			}
		}
		
		
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
