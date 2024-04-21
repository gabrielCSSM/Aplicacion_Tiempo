//
//  Json.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import Foundation

func cargarJSON(nomeArquivoJSON: String) -> ModeloTiempo {
    let datos: Data
     
    guard let arquivo = Bundle.main.url(forResource: nomeArquivoJSON,
                                  withExtension: nil)
    else {
        fatalError("\(nomeArquivoJSON) non atopado no proxecto.")
    }
     
    do {
        datos = try Data(contentsOf: arquivo)
    } catch {
        fatalError("Non foi posible cargar o arquivo \(nomeArquivoJSON): \(error)")
    }
     
    do {
        return try JSONDecoder().decode(ModeloTiempo.self, from: datos)
    } catch {
        fatalError("Non foi posible parsear o arquivo \(nomeArquivoJSON): \(error)")
    }
}
