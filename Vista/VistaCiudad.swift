//
//  VistaCiudad.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import SwiftUI

struct VistaCiudad: View {
    
    var ciudadEscogida: Ciudad
    @StateObject var modeloCiudad = CiudadModel()
    @State var listaHoras: [tiempoPorHoras] = []
    
    
    var body: some View {
        VStack{
            Text(ciudadEscogida.ciudad)
            Text(ciudadEscogida.provincia)
            HStack{
                mostrarDias(modeloCiudad: modeloCiudad, listadoHoras: $listaHoras).frame(width: 100)
                mostrarHoras(listaHoras: $listaHoras)
            }
            
            
        }.task {
            Task {
                do {
                    try await modeloCiudad.cargarDatos(
                        nuevasHoras: obtenerDatosCiudad(miCiudad: ciudadEscogida).0,
                        nuevasTemps: obtenerDatosCiudad(miCiudad: ciudadEscogida).1,
                        nuevosTiempos: obtenerDatosCiudad(miCiudad: ciudadEscogida).2)
                    
                    modeloCiudad.cargarDiario()
                    listaHoras = modeloCiudad.meteorologiaDiaria[0].horas
                    
                } catch {
                    print("error")
                }
            }
        }
    }
}

struct mostrarDias: View {
    
    @StateObject var modeloCiudad: CiudadModel
    @Binding var listadoHoras: [tiempoPorHoras]
    
    var body: some View {
        VStack{
            ForEach(modeloCiudad.meteorologiaDiaria) {
                cosa in
                
                let dia = cosa.dia.split(separator: "-")[2]
                let mes = cosa.dia.split(separator: "-")[1]
                
                let fullaño = cosa.dia.split(separator: "-")[0]
                let shrtaño = fullaño.split(separator: "20")[0]
                Button(
                    dia + "\n" + mes + "/" + shrtaño
                ) {
                    listadoHoras = cosa.horas
                }
            }
        }
        
    }
}

struct mostrarHoras: View {
    
    @Binding var listaHoras: [tiempoPorHoras]
    
    var body: some View {
        List {
            ForEach(listaHoras, id: \.id) {
                cosa in
                HStack {
                    Text("\(round(cosa.cod_tiempo))")
                    
                    Text(cosa.hora + "\n\(round(cosa.temperatura))ºC")
                }
            }
        }
    }
}


#Preview {
    VistaCiudad(ciudadEscogida: obtenerCiudades()[0])
}
