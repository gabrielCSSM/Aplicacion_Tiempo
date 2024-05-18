//
//  TiempoCiudades.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 18/5/24.
//

import Foundation

class misCiudades: ObservableObject {
    @Published var listaCiudades: [ciudad] = []
    init() {
        //
    }
    
    func añadirCiudad(provincia: String, municipio: String) {
        listaCiudades.append(ciudad(nombre: provincia, municipio: municipio))
    }
}

struct ciudad: Hashable {
    var nombre: String
    var municipio: String
}
