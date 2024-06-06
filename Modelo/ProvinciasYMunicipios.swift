//
//  TiempoCiudades.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 18/5/24.
//

import Foundation


struct ciudad: Hashable {
    var nombreCiudad: String
    var nombreMunicipio: String
    var coordLat: Double = 0.0
    var coordLong: Double = 0.0
}


func printTiempo(tiempos: [Float]) {
    for tiempo in tiempos {
        print(tiempo)
    }
}

class listaCiudades: ObservableObject {
    
    @Published var listaCiudades: [ciudad] = []
    
    init() {
        //
    }
    
    func añadirCiudad(provincia: String, municipio: String) {
        listaCiudades.append(ciudad(nombreCiudad: provincia, nombreMunicipio: municipio))
    }
}
