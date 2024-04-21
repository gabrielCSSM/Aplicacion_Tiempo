//
//  modelo.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import Foundation

struct ModeloTiempo: Decodable, Identifiable {
    var id: Int
    var cidade: String
    var tiempo: [ModeloPronostico]
    var temperatura: ModeloTemperatura
     
    enum CodingKeys: String, CodingKey {
        case id
        case cidade = "name"
        case tiempo = "weather"
        case temperatura = "main"
    }
}

struct ModeloTemperatura: Decodable {
    
    var temperaturaActual: Double
    var temperaturaMin: Double
    var temperaturaMax: Double
    var humidade: Int
    var presion: Int
    
    enum CodingKeys: String, CodingKey {
        case temperaturaActual = "temp"
        case temperaturaMin = "temp_min"
        case temperaturaMax = "temp_max"
        case humidade = "humidity"
        case presion = "pressure"
    }
}

struct ModeloPronostico: Decodable,Identifiable {
    var id: Int
    var principal: String
    var descricion: String
    var icono: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case principal = "main"
        case descricion = "description"
        case icono = "icon"
    }
}
