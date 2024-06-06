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
import SwiftSoup
import SwiftUI

func obtenerCiudades() -> [ciudad] {
        
    var ejemploCiudad1 = ciudad(nombreCiudad: "Maceda", 
                                nombreMunicipio: "Ourense",
                                coordLat: 42.27217, 
                                coordLong: -7.650074)
    
    var ejemploCiudad2 = ciudad(nombreCiudad: "Ourense",
                                nombreMunicipio: "Ourense",
                                coordLat: 42.34001,
                                coordLong: -7.864641)
    
    var ejemploCiudad3 = ciudad(nombreCiudad: "Madrid",
                                nombreMunicipio: "Madrid",
                                coordLat: 40.41669,
                                coordLong: -3.700346)
    
    var ejemploCiudad4 = ciudad(nombreCiudad: "Barcelona",
                                nombreMunicipio: "Barcelona",
                                coordLat: 41.38792,
                                coordLong: 2.169919)
    
    var ejemploCiudad5 = ciudad(nombreCiudad: "Murcia",
                                nombreMunicipio: "Murcia",
                                coordLat: 37.98344,
                                coordLong: -1.12989 )
    
    var arrayCiudades: [ciudad] = [ejemploCiudad1, ejemploCiudad2, ejemploCiudad3, ejemploCiudad4, ejemploCiudad5 ]
    
    return arrayCiudades
}

