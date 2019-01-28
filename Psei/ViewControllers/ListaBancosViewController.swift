//
//  ListaBancosViewController.swift
//  Psei
//
//  Created by Carlos Martínez on 28/01/2019.
//  Copyright © 2019 Carlos Martínez. All rights reserved.
//

import UIKit

class ListaBancosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	let alturaHeader: CGFloat = 30
	var claseBancos: [Banco] = []
	var arrBancosOrdenados: [BancosOrdenados] = []
	
	
	@IBOutlet weak var table: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        GetJsonBancos()
    }
	
	// Actualiza la tabla
	func UpdateData()
	{
		DispatchQueue.main.async {
			self.table.reloadData()
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrBancosOrdenados[section].bancos.count // claseBancos.count
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return arrBancosOrdenados.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell : UITableViewCell = table.dequeueReusableCell(withIdentifier: "cellListaBancos", for: indexPath)
		
				cell.textLabel?.text = arrBancosOrdenados[indexPath.section].bancos[indexPath.row].Codigo + " - " + arrBancosOrdenados[indexPath.section].bancos[indexPath.row].Nombre
		
				cell.detailTextLabel?.text = arrBancosOrdenados[indexPath.section].bancos[indexPath.row].FechaAlta
		
				return cell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return alturaHeader
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel()
		let letra = arrBancosOrdenados[section].letra
		
		label.text = "   \(letra)"
		label.backgroundColor = UIColor.blue
		label.textColor = UIColor.white
		
		return label
	}

	 //unción al seleccionar una fila para instanciar el viewcontroller de los Detalles y pasar los datos
		func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			let vc = storyboard?.instantiateViewController(withIdentifier: "NuevoBanco") as? NuevoBancoViewController  // DetailViewController o el nombre que le hayamos puesto al detalle
	
			vc?.banco = Banco(Id: claseBancos[indexPath.row].BancoId, Codigo: claseBancos[indexPath.row].Codigo, Nombre: claseBancos[indexPath.row].Nombre, Direccion: claseBancos[indexPath.row].Direccion ?? "", Mostrar: claseBancos[indexPath.row].Mostrar, FechaAlta: claseBancos[indexPath.row].FechaAlta)
	
	
			self.navigationController?.pushViewController(vc!, animated: true)
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
