//
//  TiempoCiudades.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 18/5/24.
//

import Foundation

// Estructura básica de una Ciudad
struct Ciudad: Hashable, Codable {
    let ciudad: String
    let provincia: String
    var coordLat: Double = 0.0
    var coordLong: Double = 0.0
    
}

// Estructura que representa el tiempo de un Dia
struct TiempoDia: Identifiable {
    let id = UUID()
    var dia: String
    let horas: [TiempoHora]
    
}

// Estructura que representa el tiempo de una Hora
struct TiempoHora {
    let id = UUID()
    let hora: String
    let temperatura: Float
    let cod_tiempo: Float
}
    
// Modelo que seguiran cada una de las Ciudades
class ModeloCiudad: ObservableObject {
    
    let miCiudad: Ciudad = Ciudad(ciudad: "", provincia: "")
    
    @Published var horasCiudad: [String] = []
    @Published var tempsCiudad: [Float] = []
    @Published var tiempoCiudad: [Float] = []
    @Published var meteorologiaDiaria: [TiempoDia] = []
    
    init(){}
    
    func cargarDatos(nuevasHoras: [String], nuevasTemps: [Float], nuevosTiempos: [Float]) async throws{
        horasCiudad = nuevasHoras
        tempsCiudad = nuevasTemps
        tiempoCiudad = nuevosTiempos
    }
    
    func cargarDiario() {
        
        var anteriorDia = String(horasCiudad[0].split(separator: "_")[0])
        var diaActual = ""
        var arrayHoras: [TiempoHora] = []
        meteorologiaDiaria = []
        
        for contador in 0..<horasCiudad.count {
            
            diaActual = String(horasCiudad[contador].split(separator: "_")[0])
        
            if(anteriorDia != diaActual) {
                
                meteorologiaDiaria.append(TiempoDia(dia: anteriorDia, horas: arrayHoras))
                
                anteriorDia = diaActual
                
                arrayHoras = []
                
                let tempTiempo = TiempoHora(
                    hora: String(horasCiudad[contador].split(separator: "_")[1]),
                    temperatura: tempsCiudad[contador],
                    cod_tiempo: tiempoCiudad[contador]
                )
                
                arrayHoras.append(tempTiempo)
                
            } else {
                
                let tempTiempo = TiempoHora(
                    hora: String(horasCiudad[contador].split(separator: "_")[1]),
                    temperatura: tempsCiudad[contador],
                    cod_tiempo: tiempoCiudad[contador]
                )
                
                arrayHoras.append(tempTiempo)
                
            }
        }
    }
}

class ListadoCiudades: ObservableObject {
    
    @Published var listaCiudades: [Ciudad] = []
    
    init() {
        //
    }
    
    func añadirCiudad(nombreCiudad: String, nombreProvincia: String) {
        for ciudade in ColeccionCiudades() {
            if (ciudade.ciudad.elementsEqual(nombreCiudad) &&
                ciudade.provincia.elementsEqual(nombreProvincia)) {
                listaCiudades.append(ciudade)
            }
        }
    }
}

func ColeccionCiudades() -> [Ciudad] {
        
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
    
    let arrayCiudades: [Ciudad] = [ejemploCiudad1, ejemploCiudad2, ejemploCiudad3, ejemploCiudad4, ejemploCiudad5]
    
    return arrayCiudades
}


func DevolverProvincias() -> [String] {
    var arrayProvincias: [String] = []
    
    for ciudade in ColeccionCiudades() {
        if (!arrayProvincias.contains(ciudade.provincia)) {
            arrayProvincias.append(ciudade.provincia)
        }
    }
    
    return arrayProvincias
}

func DevolverCiudades(provincia: String) -> [String] {
    var arrayCiudades: [String] = []
    
    for ciudade in ColeccionCiudades() {
        if(ciudade.provincia.elementsEqual(provincia)){
            arrayCiudades.append(ciudade.ciudad)
        }
    }
    
    return arrayCiudades
}
