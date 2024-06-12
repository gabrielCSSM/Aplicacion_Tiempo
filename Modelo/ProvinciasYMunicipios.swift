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
    
}

struct tiempoDiario: Identifiable {
    let id = UUID()
    var dia: String
    let horas: [tiempoPorHoras]
    
}

struct tiempoPorHoras {
    let id = UUID()
    let hora: String
    let temperatura: Float
    let cod_tiempo: Float
}
    
class CiudadModel: ObservableObject {
    let miCiudad: Ciudad = Ciudad(ciudad: "", provincia: "")
    
    @Published var horasCiudad: [String] = []
    @Published var tempsCiudad: [Float] = []
    @Published var tiempoCiudad: [Float] = []
    @Published var meteorologiaDiaria: [tiempoDiario] = []
    
    init(){}
    
    func cargarDatos(nuevasHoras: [String], nuevasTemps: [Float], nuevosTiempos: [Float]) async throws{
        horasCiudad = nuevasHoras
        tempsCiudad = nuevasTemps
        tiempoCiudad = nuevosTiempos
    }
    
    func cargarDiario() {
        
        var anteriorDia = String(horasCiudad[0].split(separator: "_")[0])
        var diaActual = ""
        var arrayHoras: [tiempoPorHoras] = []
        meteorologiaDiaria = []
        
        for contador in 0..<horasCiudad.count {
            
            diaActual = String(horasCiudad[contador].split(separator: "_")[0])
        
            if(anteriorDia != diaActual) {
                
                
                meteorologiaDiaria.append(tiempoDiario(dia: anteriorDia, horas: arrayHoras))
                anteriorDia = diaActual
                arrayHoras = []
                
                let tempTiempo = tiempoPorHoras(
                    hora: String(horasCiudad[contador].split(separator: "_")[1]),
                    temperatura: tempsCiudad[contador],
                    cod_tiempo: tiempoCiudad[contador]
                )
                
                arrayHoras.append(tempTiempo)
                
            } else {
                
                let tempTiempo = tiempoPorHoras(
                    hora: String(horasCiudad[contador].split(separator: "_")[1]),
                    temperatura: tempsCiudad[contador],
                    cod_tiempo: tiempoCiudad[contador]
                )
                
                arrayHoras.append(tempTiempo)
                
            }
        }
    }
}

class listaCiudades: ObservableObject {
    
    @Published var listaCiudades: [Ciudad] = []
    
    init() {
        //
    }
    
    func añadirCiudad(nombreCiudad: String, nombreProvincia: String) {
        for ciudade in obtenerCiudades() {
            if (ciudade.ciudad.elementsEqual(nombreCiudad) &&
                ciudade.provincia.elementsEqual(nombreProvincia)) {
                listaCiudades.append(ciudade)
            }
        }
    }
}

