//
//  ObtenerTiempo.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 22/5/24.
//

/*
 
 En esta clase se Obtendra los datos del tiempo de la ciudad Introducida
 
 */

import OpenMeteoSdk
import Foundation
import SwiftUI

/// Make sure the URL contains `&format=flatbuffers`

func obtenerDatosCiudad(miCiudad: Ciudad) async throws -> ([String], [Float], [Float]) {
    let esperarDatos = Task { () -> ([String], [Float], [Float]) in
        
        let myfunc = await llamarAPI(latitude: miCiudad.coordLat, longitude: miCiudad.coordLong)
        
        var tempArrayHoras: [String] =  []
        var tempArrayTemps: [Float] =  []
        var tempArrayTiempo: [Float] =  []
        
        for dato in myfunc {
            tempArrayHoras.append(String(dato.split(separator: ";")[0]))
            tempArrayTemps.append(Float(dato.split(separator: ";")[1]) ?? 0.0)
            tempArrayTiempo.append(Float(dato.split(separator: ";")[2]) ?? 0.0)
        }
        
        return (tempArrayHoras, tempArrayTemps, tempArrayTiempo)
    }
    
    
    let datosRecibidos = await esperarDatos.result
    
    do {
        return try datosRecibidos.get()
    } catch {
        print("Something Happened")
        return([],[],[])
    }
    
}

func llamarAPI(latitude: Double, longitude: Double) async -> [String] {
    
    let url = URL(string:"https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,weather_code&forecast_days=14&format=flatbuffers")!
    
    do {
        
        let respuestas = try await WeatherApiResponse.fetch(url: url)
        let respuesta = respuestas[0];
        
        /// Attributes for timezone and location
        let utcOffsetSeconds = respuesta.utcOffsetSeconds
        let timezone = respuesta.timezone
        let timezoneAbbreviation = respuesta.timezoneAbbreviation
        let latitude = respuesta.latitude
        let longitude = respuesta.longitude
        
        let hourly = respuesta.hourly!
        
        struct WeatherData {
            
            let hourly: Hourly
            
            struct Hourly {
                let time: [Date]
                let temperature2m: [Float]
                let weatherCode: [Float]
            }
        }
        
        /// Note: The order of weather variables in the URL query and the `at` indices below need to match!
        let data = WeatherData(
            hourly: .init(
                time: hourly.getDateTime(offset: utcOffsetSeconds),
                temperature2m: hourly.variables(at: 0)!.values,
                weatherCode: hourly.variables(at: 1)!.values
            )
        )
        
        /// Timezone `.gmt` is deliberately used.
        /// By adding `utcOffsetSeconds` before, local-time is inferred
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm"
        
        
        var tempArray: [String] = []
        for (i, date) in data.hourly.time.enumerated() {
            let mystring = ("\(dateFormatter.string(from: date));\(data.hourly.temperature2m[i]);\(data.hourly.weatherCode[i])")
            tempArray.append(mystring)
        }
        
        return tempArray
        
    }catch {
        fatalError()
    }
}

func obtenerIconoTiempo(codigo: Float) -> Image {
    switch codigo {
        case 0:
            // Despejado
            return Image.init(systemName: "sun.max.fill")
        case 1,2,3:
            // Casi Despejado
            return Image.init(systemName: "cloud.sun.fill")
        case 45,48:
            // Con niebla
            return Image.init(systemName: "cloud.fog.fill")
        case 51,53,55:
            // Con llovizna
            return Image.init(systemName: "cloud.drizzle.fill")
        case 56,57:
            // Llovizan con granizo
            return Image.init(systemName: "cloud.hail")
        case 61,63,65:
            // Lluvia
            return Image.init(systemName: "cloud.rain.fill")
        case 66,67:
            // LLuvia y Granizo
            return Image.init(systemName: "cloud.sleet")
        case 71,73,75:
            // Nieve
            return Image.init(systemName: "cloud.snow.fill")
        case 77:
            // Nevada
            return Image.init(systemName: "wind.snow")
        case 80,81,82:
            // LLuvias intensas
            return Image.init(systemName: "cloud.rain.fill")
        case 85,86:
            // Nieve intensa
            return Image.init(systemName: "cloud.snow.fill")
        default:
            return Image.init(systemName: "cloud.fill")
    }
}
