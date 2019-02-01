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
	
	let searchController = UISearchController(searchResultsController: nil)
	
	@IBOutlet weak var searchBar: UISearchBar!
	
	@IBOutlet weak var table: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        GetJsonBancos()
		
		arrBancosFiltered = arrBancosOrdenados
		
		setupNavigation()

    }
	
	func setupNavigation()
	{
		if #available(iOS 11.0, *) {
			navigationController?.title = "Nuevo Banco"
			navigationController?.navigationBar.prefersLargeTitles = true
		} else {
			// Fallback on earlier versions
		}
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
						return $0.Nombre.lowercased().contains(textoABuscar)
					}
					//return scopeNames[indexFiltro] == "Nombre" ? $0.Nombre.lowercased().contains(textoABuscar.lowercased()) : $0.Codigo.lowercased().contains(textoABuscar.lowercased())
					//return $0.Nombre.contains(textoABuscar)
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

	func numberOfSections(in tableView: UITableView) -> Int {
		
		if isFiltered //& arrBancosFiltered.count > 0
		{
			return arrBancosFiltered.count
		}
		else {
			return arrBancosOrdenados.count
		}
	}
	
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
			let vc = storyboard?.instantiateViewController(withIdentifier: "NuevoBanco") as? NuevoBancoViewController  // DetailViewController o el nombre que le hayamos puesto al detalle
			
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
	
	
	
	
	
	
	// REMARK: - Coger el JSON del WEBAPI
	func GetJsonBancos()
	{
		let cadenaApi = "http://webapi.camasa.es/api/Bancos"
		
		guard let url = URL(string: cadenaApi) else { return }
		
		URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
			
			if let response = response {
				print (response)
			}
			
			guard let data = data else { return }
			
			do
			{
				//let structura =  try JSONDecoder().decode([bancos].self, from: data)
				let structura =  try JSONDecoder().decode([Banco].self, from: data)
				self.claseBancos.removeAll()
				
				for banco in structura
				{
					let newBanco = Banco(Id: banco.BancoId, Codigo: banco.Codigo, Nombre: banco.Nombre, Direccion: banco.Direccion ?? "", Mostrar: banco.Mostrar, FechaAlta: banco.FechaAlta)
					
					self.claseBancos.append(newBanco)
				}
				
				for	banco in self.claseBancos
				{
					let letra = banco.Nombre.prefix(1)
					
					if let encontrado = self.arrBancosOrdenados.first(where: {$0.letra == letra})
					{
						// Encontrado
						encontrado.bancos.append(banco)
					}
					else
					{
						// No encontrado
						let bo: BancosOrdenados = BancosOrdenados(letra: String(letra), bancos: [banco])
						self.arrBancosOrdenados.append(bo)
					}
					
				}
				
				self.arrBancosOrdenados.sort(by: { $0.letra  < $1.letra })
				
				//self.claseBancos.sort(by: { $0.Nombre < $1.Nombre })
				self.UpdateData()
				
				//print(self.arrBancosOrdenados)
				
			}catch let jsonError{
				print ("Error serializando json ", jsonError)
			}
			
		}).resume()
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

//extension ListaBancosViewController: UISearchResultsUpdating
//{
//	func updateSearchResults(for searchController: UISearchController) {
//		arrBancosFiltered.removeAll()
//
//		for registro in arrBancosOrdenados {
//			for banco in registro.bancos
//			{
//				if banco.Nombre == searchBar!.text
//				{
//					arrBancosFiltered.append(<#T##newElement: BancosOrdenados##BancosOrdenados#>)
//				}
//			}
//		}
//
//
//		//arrBancosFiltered = arrBancosOrdenados.filter({ $0.bancos. .contains(where: 	searchBar!.text)  })
//	}
//
//	func searchBarIsEmpty()
//	{
//
//	}
//
//
//
//
//}
