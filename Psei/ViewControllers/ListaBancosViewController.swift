//
//  ListaBancosViewController.swift
//  Psei
//
//  Created by Carlos Martínez on 28/01/2019.
//  Copyright © 2019 Carlos Martínez. All rights reserved.
//

import UIKit

class ListaBancosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
	let alturaHeader: CGFloat = 30
	var claseBancos: [Banco] = []
	var arrBancosOrdenados: [BancosOrdenados] = []
	var arrBancosFiltered: [BancosOrdenados] = []
	var isFiltered = false
	
	let scopeNames = ["Codigo", "Nombre"]
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var table: UITableView!
	@IBOutlet weak var indicador: UIActivityIndicatorView!


	override func viewDidLoad() {
        super.viewDidLoad()

		indicador.hidesWhenStopped = true
		indicador.startAnimating()
		
		Banco.GetJson(completion: { (response) in
			self.arrBancosOrdenados = response
			
			DispatchQueue.main.async {
				
				self.table.reloadData()
				self.indicador.stopAnimating()
			}
			
		})
		print("En el hilo principal")
        //GetJsonBancos()
		
		arrBancosFiltered = arrBancosOrdenados
		
		setupNavigation()

    }
	
	func setupNavigation()
	{
//		if #available(iOS 11.0, *) {
//			navigationController?.title = "Nuevo Banco"
//			navigationController?.navigationBar.prefersLargeTitles = true
//		} else {
//			// Fallback on earlier versions
//		}
	}
	
	// Actualiza la tabla
	func UpdateData()
	{
		DispatchQueue.main.async {
			self.table.reloadData()
		}
	}
	
	// Método que filtra los datos
	func filtrar(_ textoABuscar: String, indexFiltro: Int = 0)
	{
			arrBancosFiltered.removeAll()
		
		arrBancosFiltered = arrBancosOrdenados.map({
			return BancosOrdenados(
				letra: $0.letra,
				bancos: $0.bancos.filter({
					if indexFiltro == 0
					{
						return ($0.Codigo).lowercased().contains(textoABuscar)
					}
					else{
						return ($0.Nombre).lowercased().contains(textoABuscar)
					}
				})
			)
		}).filter { $0.bancos.count > 0 }
		
		//isFiltered = arrBancosFiltered.count > 0
		
		table.reloadData()
	}
	
	
	// Cuando cambia el scope
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		
		if isFiltered && searchBar.text != ""
		{
			filtrar(searchBar.text!.lowercased(), indexFiltro: selectedScope)
		}
	}
	
	// Cuando se escribe en el buscador
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		if searchText.count > 0
		{
			isFiltered = true
			filtrar(searchText.lowercased(), indexFiltro: searchBar.selectedScopeButtonIndex)
			
		}
		else{
			
			isFiltered = false
			//searchBar.selectedScopeButtonIndex  = 1
			table.reloadData()
		}
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if 	isFiltered  //&& arrBancosFiltered.count > 0
		{
			return arrBancosFiltered[section].bancos.count
		}
		else
		{
			return arrBancosOrdenados[section].bancos.count
		}
	}
	
	// Función para editar la celda: DELETE, INSERT
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		
		if isFiltered //& arrBancosFiltered.count > 0
		{
			return arrBancosFiltered.count
		}
		else {
			return arrBancosOrdenados.count
		}
	}
	
	// Ponemos los valores en la celda
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell : UITableViewCell = table.dequeueReusableCell(withIdentifier: "cellListaBancos", for: indexPath)
		
		if isFiltered
		{
			if arrBancosFiltered.count > 0
			{
				cell.textLabel?.text = arrBancosFiltered[indexPath.section].bancos[indexPath.row].Codigo + " - " + arrBancosFiltered[indexPath.section].bancos[indexPath.row].Nombre
			
				cell.detailTextLabel?.text = arrBancosFiltered[indexPath.section].bancos[indexPath.row].FechaAlta
			}
		}
		else
		{
			if arrBancosOrdenados.count > 0
			{
				cell.textLabel?.text = arrBancosOrdenados[indexPath.section].bancos[indexPath.row].Codigo + " - " + arrBancosOrdenados[indexPath.section].bancos[indexPath.row].Nombre
		
				cell.detailTextLabel?.text = arrBancosOrdenados[indexPath.section].bancos[indexPath.row].FechaAlta
			}
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return alturaHeader
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel()
		let letra = isFiltered && arrBancosFiltered.count > 0 ? arrBancosFiltered[section].letra : arrBancosOrdenados[section].letra
		
		label.text = "   \(letra)"
		label.backgroundColor = UIColor.blue
		label.textColor = UIColor.white
		
		return label
	}

	 // Función al seleccionar una fila para instanciar el viewcontroller de los Detalles y pasar los datos
		func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			let vc = storyboard?.instantiateViewController(withIdentifier: "ModificarBanco") as? ModificarBancoViewController  // DetailViewController o el nombre que le hayamos puesto al detalle

			if isFiltered && arrBancosFiltered.count > 0
			{
				vc?.banco = Banco(Id: arrBancosFiltered[indexPath.section].bancos[indexPath.row].BancoId, Codigo: arrBancosFiltered[indexPath.section].bancos[indexPath.row].Codigo, Nombre: arrBancosFiltered[indexPath.section].bancos[indexPath.row].Nombre, Direccion: arrBancosFiltered[indexPath.section].bancos[indexPath.row].Direccion ?? "", Mostrar: arrBancosFiltered[indexPath.section].bancos[indexPath.row].Mostrar, FechaAlta: arrBancosFiltered[indexPath.section].bancos[indexPath.row].FechaAlta)
				
			}
			else {
				vc?.banco = Banco(Id: arrBancosOrdenados[indexPath.section].bancos[indexPath.row].BancoId, Codigo: arrBancosOrdenados[indexPath.section].bancos[indexPath.row].Codigo, Nombre: arrBancosOrdenados[indexPath.section].bancos[indexPath.row].Nombre, Direccion: arrBancosOrdenados[indexPath.section].bancos[indexPath.row].Direccion ?? "", Mostrar: arrBancosOrdenados[indexPath.section].bancos[indexPath.row].Mostrar, FechaAlta: arrBancosOrdenados[indexPath.section].bancos[indexPath.row].FechaAlta)
			}
				self.navigationController?.pushViewController(vc!, animated: true)
		}
	
	// Ponemos las letras a la derecha como índice
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		
		if isFiltered
		{
			return arrBancosFiltered.map({ $0.letra })
		}
		else
		{
			return arrBancosOrdenados.map({ $0.letra })
		}
		
	}
}

