//
//  VistaCiudad.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import SwiftUI

struct VistaCiudad: View {
    @ObservedObject var ciudadEscogida: Ciudad
    @State var actulizacionDatos: ([String], [Float], [Float])?
    
    var body: some View {
        VStack{
            Text(ciudadEscogida.ciudad)
            Text(ciudadEscogida.provincia)
            
            ForEach(ciudadEscogida.horasCiudad, id: \.self) {
                hora in  
                Text(hora)
            }
        
        }.onAppear {
            Task {
                do {
                    let datos = try await obtenerDatosCiudad(miCiudad: ciudadEscogida)
                    actulizacionDatos?.0 = datos.0
                    actulizacionDatos?.1 = datos.1
                    actulizacionDatos?.2 = datos.2
                } catch {
                    print("error")
                }
                
                await MainActor.run {
                    actualizar()
                }
                
                print("On task")
                print(ciudadEscogida.horasCiudad)
            }
        }
    }
    
    func actualizar() {
        rellenarCiudad(miCiudad: ciudadEscogida, horas: actulizacionDatos!.0, temp: actulizacionDatos!.1, tiempo: actulizacionDatos!.2)
    }
}



#Preview {
    VistaCiudad(ciudadEscogida: obtenerCiudades()[0])
}
