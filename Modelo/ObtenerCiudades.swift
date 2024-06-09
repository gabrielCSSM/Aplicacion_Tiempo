//
//  ObtenerCiudades.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 22/5/24.
//

/*
 
 En esta clase se Obtendra los datos de todas las ciudades
 
 */

import Foundation
import SwiftUI

func obtenerCiudades() -> [Ciudad] {
        
    let ejemploCiudad1 = Ciudad(ciudad: "Maceda",
                                provincia: "Ourense",
                                coordLat: 42.27217, 
                                coordLong: -7.650074)
    
    let ejemploCiudad2 = Ciudad(ciudad: "Ourense",
                                provincia: "Ourense",
                                coordLat: 42.34001,
                                coordLong: -7.864641)
    
    let ejemploCiudad3 = Ciudad(ciudad: "Madrid",
                                provincia: "Madrid",
                                coordLat: 40.41669,
                                coordLong: -3.700346)
    
    let ejemploCiudad4 = Ciudad(ciudad: "Barcelona",
                                provincia: "Barcelona",
                                coordLat: 41.38792,
                                coordLong: 2.169919)
    
    let ejemploCiudad5 = Ciudad(ciudad: "Murcia",
                                provincia: "Murcia",
                                coordLat: 37.98344,
                                coordLong: -1.12989 )
    
    let arrayCiudades: [Ciudad] = [ejemploCiudad1, ejemploCiudad2, ejemploCiudad3, ejemploCiudad4, ejemploCiudad5 ]
    
    return arrayCiudades
}

func devolverProvincias() -> [String] {
    var arrayMunicipios: [String] = []
    for ciudade in obtenerCiudades() {
        if (!arrayMunicipios.contains(ciudade.provincia)) {
            arrayMunicipios.append(ciudade.provincia)
        }
    }
    
    return arrayMunicipios
}

func devolverCiudades(provincia: String) -> [String] {
    var arrayCiudades: [String] = []
    for ciudade in obtenerCiudades() {
        if(ciudade.provincia.elementsEqual(provincia)){
            arrayCiudades.append(ciudade.ciudad)
        }
    }
    return arrayCiudades
}
