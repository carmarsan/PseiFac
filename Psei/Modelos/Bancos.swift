//
//  Bancos.swift
//  Psei
//
//  Created by Carlos Martínez on 28/01/2019.
//  Copyright © 2019 Carlos Martínez. All rights reserved.
//

import UIKit

// Clase para rellenar los datos que vienen del WebApi
class Banco: Decodable {
	
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
	
	
}

class BancosOrdenados {
	var letra: String
	var bancos: [Banco]
	
	init(letra: String, bancos: [Banco]) {
		self.letra = letra
		self.bancos = bancos
	}
}
