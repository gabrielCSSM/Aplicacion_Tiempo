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

/// Make sure the URL contains `&format=flatbuffers`




func obtenerDatosCiudades() {
    for cadaCiudad in obtenerCiudades() {
        print(cadaCiudad)
        print("\n")
        
        Task {
            let myfunc = await llamarAPI(latitude: cadaCiudad.coordLat, longitude: cadaCiudad.coordLong)
            print(myfunc)
            print("\n")
        }
    }
}

func llamarAPI(latitude: Double, longitude: Double) async -> [String] {
    
    let url = URL(string:"https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m&format=flatbuffers")!
    
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
            }
        }
        
        /// Note: The order of weather variables in the URL query and the `at` indices below need to match!
        let data = WeatherData(
            hourly: .init(
                time: hourly.getDateTime(offset: utcOffsetSeconds),
                temperature2m: hourly.variables(at: 0)!.values
            )
        )
        
        /// Timezone `.gmt` is deliberately used.
        /// By adding `utcOffsetSeconds` before, local-time is inferred
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = .gmt
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm"
        
        
        var tempArray: [String] = []
        for (i, date) in data.hourly.time.enumerated() {
            var mystring = ("\(dateFormatter.string(from: date));\(data.hourly.temperature2m[i])")
            tempArray.append(mystring)
        }
        
        return tempArray
        
    }catch {
        fatalError()
    }
}
