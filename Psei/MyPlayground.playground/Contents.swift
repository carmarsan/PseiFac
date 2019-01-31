import UIKit

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


var ordenado: [BancosOrdenados] = []
var filtrado: [BancosOrdenados] = []

var banco1: [Banco] = [Banco(Id: 0, Codigo: "0", Nombre: "0", Direccion: "0", Mostrar: true, FechaAlta: ""),
					   Banco(Id: 1, Codigo: "1", Nombre: "1", Direccion: "1", Mostrar: true, FechaAlta: ""),
					   Banco(Id: 2, Codigo: "2", Nombre: "2", Direccion: "2", Mostrar: true, FechaAlta: "")]

var banco2: [Banco] = [Banco(Id: 3, Codigo: "3", Nombre: "0", Direccion: "0", Mostrar: true, FechaAlta: ""),
					   Banco(Id: 4, Codigo: "4", Nombre: "1", Direccion: "1", Mostrar: true, FechaAlta: ""),
					   Banco(Id: 5, Codigo: "5", Nombre: "2", Direccion: "2", Mostrar: true, FechaAlta: "")]

ordenado.append(BancosOrdenados(letra: "A", bancos: banco1))
ordenado.append(BancosOrdenados(letra: "B", bancos: banco2))


//let fil = ordenado.flatMap { $0.bancos }.flatMap{ $0.Codigo }

//print(fil)

let bak = ordenado.flatMap { $0.bancos }

print(bak)
