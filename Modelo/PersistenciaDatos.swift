//
//  PersistenciaDatos.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 13/6/24.
//

import Foundation
class PersistenciaDatos {
    
    static func saveData(listado: [Ciudad]) -> Data {
        
        guard let data = try? JSONEncoder().encode(listado) else {
             return Data()
        }
        
        return data
    }
    
    static func retrieveData(datos: Data) -> [Ciudad]{
        guard let listado = try? JSONDecoder().decode([Ciudad].self, from: datos) else {
            return []
        }
        return listado
    }
}
