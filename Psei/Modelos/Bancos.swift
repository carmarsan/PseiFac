//
//  Bancos.swift
//  Psei
//
//  Created by Carlos Martínez on 28/01/2019.
//  Copyright © 2019 Carlos Martínez. All rights reserved.
//

import UIKit

// Clase para rellenar los datos que vienen del WebApi
//class Banco: Decodable {
class Banco: Codable {
	var BancoId: Int
	var Codigo: String
	var Nombre: String
	var Direccion: String?
	var Mostrar: Bool
	var FechaAlta: String
	
	convenience init(){
		self.init(Id: 0, Codigo: "", Nombre: "", Direccion: "", Mostrar: true, FechaAlta: "")
	}
	
	init(Id: Int, Codigo: String, Nombre: String, Direccion: String, Mostrar: Bool, FechaAlta: String) {
		self.BancoId = Id
		self.Codigo = Codigo
		self.Nombre = Nombre
		self.Direccion = Direccion
		self.Mostrar = Mostrar
		self.FechaAlta = FechaAlta
	}
	
	class func GetJson(completion: @escaping (_ response: [BancosOrdenados]) -> Void)
	{
		let urlSW = "http://webapi.camasa.es/api/Bancos"
		var claseBancos: [Banco] = []
		var arrBancosOrdenados: [BancosOrdenados] = []
		
		guard let url = URL(string: urlSW) else { return }
		
		URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
			
			if let response = response {
				print (response)
			}
			
			guard let data = data else { return }
			
			do
			{
				let structura =  try JSONDecoder().decode([Banco].self, from: data)
				
				for banco in structura
				{
					let newBanco = Banco(Id: banco.BancoId, Codigo: banco.Codigo, Nombre: banco.Nombre, Direccion: banco.Direccion ?? "", Mostrar: banco.Mostrar, FechaAlta: banco.FechaAlta)
					
					claseBancos.append(newBanco)
				}
				
				for	banco in claseBancos
				{
					let letra = banco.Nombre.prefix(1)
					
					if let encontrado = arrBancosOrdenados.first(where: {$0.letra == letra})
					{
						// Encontrado
						encontrado.bancos.append(banco)
					}
					else
					{
						// No encontrado
						let bo: BancosOrdenados = BancosOrdenados(letra: String(letra), bancos: [banco])
						arrBancosOrdenados.append(bo)
					}
					
				}
				
				arrBancosOrdenados.sort(by: { $0.letra  < $1.letra })
				completion(arrBancosOrdenados)
				
			}catch let jsonError{
				print ("Error serializando json ", jsonError)
			}
			
		}).resume()
	}

	class func Save(banco: Banco, completionHandler:((Error?) -> Void)?)
	{
//		var urlComponents = URLComponents()
//		urlComponents.scheme = "http"
//		urlComponents.host = "jsonplaceholder.typicode.com"
//		urlComponents.path = "/posts"
//		guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
		
		let urlSW = "http://webapi.camasa.es/api/Bancos/" + String(banco.BancoId)  // para PUT
		//let urlSW = "http://webapi.camasa.es/api/Bancos"  para POST
		
		guard let url = URL(string: urlSW) else { return }
		
		// Specify this request as being a POST method
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		// Make sure that we include headers specifying that our request's HTTP body
		// will be JSON encoded
		var headers = request.allHTTPHeaderFields ?? [:]
		headers["Content-Type"] = "application/json"
		request.allHTTPHeaderFields = headers
		
		// Now let's encode out Post struct into JSON data...
		let encoder = JSONEncoder()
		do {
			let jsonData = try encoder.encode(banco)
			// ... and set our request's HTTP body
			request.httpBody = jsonData
			print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
		} catch {
			completionHandler?(error)
		}
		
		// Create and run a URLSession data task with our JSON encoded POST request
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		let task = session.dataTask(with: request) { (responseData, response, responseError) in
			guard responseError == nil else {
				completionHandler?(responseError!)
				return
			}
			
			// APIs usually respond with the data you just sent in your POST request
			if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
				print("response: ", utf8Representation)
			} else {
				print("no readable data received in response")
			}
		}
		task.resume()
	}
	
//	func submitPost(post: Post, completion:((Error?) -> Void)?) {
//		var urlComponents = URLComponents()
//		urlComponents.scheme = "https"
//		urlComponents.host = "jsonplaceholder.typicode.com"
//		urlComponents.path = "/posts"
//		guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
//
//
//	}
	
}

class BancosOrdenados {
	var letra: String
	var bancos: [Banco]
	
	init(letra: String, bancos: [Banco]) {
		self.letra = letra
		self.bancos = bancos
	}
}
