//
//  TiempoCiudades.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 18/5/24.
//

import Foundation



struct Ciudad: Hashable {
    let ciudad: String
    let provincia: String
    var coordLat: Double = 0.0
    var coordLong: Double = 0.0
    var horasCiudad: [String] = []
    var tempsCiudad: [Float] = []
}


class listaCiudades: ObservableObject {
    
    @Published var listaCiudades: [Ciudad] = []
    
    init() {
        //
    }
    
    func añadirCiudad(nombreCiudad: String, nombreProvincia: String) {
        let nuevaCiudad: Ciudad = Ciudad(ciudad: nombreCiudad, provincia: nombreProvincia)
        listaCiudades.append(nuevaCiudad)
    }
}

