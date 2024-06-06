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

func obtenerURL() -> (String, String) {
    var latitudes: String = "latitude="
    var longitudes: String = "longitude="

    for(anyCiudad) in obtenerCiudades() {
        latitudes = latitudes.appending(String(anyCiudad.coordLat) + ",")
        longitudes = longitudes.appending(String(anyCiudad.coordLong) + ",")

    }
    
    latitudes.removeLast()
    longitudes.removeLast()
    
    return (latitudes, longitudes)
}

/// Make sure the URL contains `&format=flatbuffers`
let url = URL(string:
                "https://api.open-meteo.com/v1/forecast?" + obtenerURL().0 + "&"
                + obtenerURL().1 +
                "&hourly=temperature_2m&format=flatbuffers")!

func llamarAPI()  {
    
    print("entro funcion")
    
    
    do {
        
        print("entro do")
        
        Task {
            print("entro task")
            
            let respuestas = try await WeatherApiResponse.fetch(url: url)
            
            print("salgo respuestas")
            
            /// Process first location. Add a for-loop for multiple locations or weather models
            for respuesta in respuestas {
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
                
                printTiempo(tiempos: data.hourly.temperature2m)
                
                /// Timezone `.gmt` is deliberately used.
                /// By adding `utcOffsetSeconds` before, local-time is inferred
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = .gmt
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                
                for (i, date) in data.hourly.time.enumerated() {
                    print(dateFormatter.string(from: date))
                    print(data.hourly.temperature2m[i])
                }
            }
        }
        
        
        
    } catch {
            fatalError("Fallo")
        }
    }

