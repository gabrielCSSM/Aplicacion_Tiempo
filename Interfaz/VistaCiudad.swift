//
//  VistaCiudad.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import SwiftUI

struct VistaCiudad: View {
    // Variables de control de la Ciudad
    var ciudadEscogida: Ciudad
    @StateObject var modeloCiudad = ModeloCiudad()
    @State var listaHoras: [TiempoHora] = []
    @State var fechaSeleccionada: String = ""
    
    // Variables de control de la interfaz
    @Binding var modoPresentacion: Bool
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack{
            
            HStack {
                // Cuando se presiona el boton se cierra la venta actual
                Button(action: {
                    
                    dismiss()
                    
                }, label: {
                    
                    Image(systemName:"arrowshape.turn.up.backward.fill")
                    
                }).font(.title2.bold())
                    .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                    .frame(height: 60)
                    .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 10)
                    .frame(alignment: .trailing)
                
                // Titulo de la Ciudad
                VStack {
                    Text(ciudadEscogida.ciudad + ", " + ciudadEscogida.provincia)
                        .font(.title2.bold())
                        .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                        .frame(height: 60)
                        .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 10)
                    Text(fechaSeleccionada)
                        .font(.headline.bold())
                        .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                        .frame(height: 7)
                        .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 10)
                }
                
            }
            
            HStack {
                mostrarDias(modeloCiudad: modeloCiudad, listadoHoras: $listaHoras, modoPresentacion: $modoPresentacion, fechaSeleccionada: $fechaSeleccionada)
                mostrarHoras(listaHoras: $listaHoras, modoPresentacion: $modoPresentacion)
            }
            
        }.task {
            Task {
                // Cargar todos los datos de la Ciudad
                do {
                    
                    try await modeloCiudad.cargarDatos(
                        nuevasHoras: ObtenerDatosCiudad(miCiudad: ciudadEscogida).0,
                        nuevasTemps: ObtenerDatosCiudad(miCiudad: ciudadEscogida).1,
                        nuevosTiempos: ObtenerDatosCiudad(miCiudad: ciudadEscogida).2)
                    
                    modeloCiudad.cargarDiario()
                    
                    listaHoras = modeloCiudad.meteorologiaDiaria[0].horas
                    fechaSeleccionada = modeloCiudad.meteorologiaDiaria[0].dia.replacingOccurrences(of: "_", with: "/")
                    
                } catch {
                    fatalError("Ocurrio algo intentando cargar los Datos")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 5)
        .background(modoPresentacion ? modoOscuro.colorMainFondo : modoClaro.colorMainFondo)
        .presentationBackground(.clear)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? modoOscuro.colorBordes : modoClaro.colorBordes, lineWidth: 1))
        .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 20)
        
        
    }
}

struct mostrarDias: View {
    
    @StateObject var modeloCiudad: ModeloCiudad
    @Binding var listadoHoras: [TiempoHora]
    @Binding var modoPresentacion: Bool
    @Binding var fechaSeleccionada: String
    
    var body: some View {
        
        ScrollView(.vertical){
            
            ForEach(modeloCiudad.meteorologiaDiaria) {
                diarioCiudad in
                
                let dia = diarioCiudad.dia.split(separator: "-")[2]
                let mes = diarioCiudad.dia.split(separator: "-")[1]
                let diaMes: String = dia + " / " + mes
                
                Button(action: {
                    
                    listadoHoras = diarioCiudad.horas
                    fechaSeleccionada = diarioCiudad.dia.replacingOccurrences(of: "_", with: "/")
                    
                }, label: {
                    
                    Text(diaMes)
                        .font(.headline.italic())
                        .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                        .frame(height: 60)
                    
                })
                .frame(maxWidth: .infinity, alignment: .center)
                .background(modoPresentacion ? modoOscuro.ventanaFondo : modoClaro.ventanaFondo)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? modoOscuro.colorBordes : modoClaro.colorBordes, lineWidth: 1))
                .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 1)
            }
        }.padding(.all, 5)
            .background(.clear)
            .scrollContentBackground(Visibility.hidden)
            .listRowSpacing(20)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .containerRelativeFrame(.horizontal) {
                length, _ in
                length * 0.30
            }
    }
}

struct mostrarHoras: View {
    
    @Binding var listaHoras: [TiempoHora]
    @Binding var modoPresentacion: Bool
    
    var body: some View {
        
        ScrollView(.vertical){
            
            ForEach(listaHoras, id: \.id) {
                cadaHora in
                
                HStack {
                    
                    ObtenerIconoTiempo(codigo: cadaHora.cod_tiempo).scaledToFit()
                        .font(.headline.italic())
                        .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                        .frame(height: 60)
                    
                    Text(cadaHora.hora + "\n\(round(cadaHora.temperatura))ºC")
                        .font(.headline.bold())
                        .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                        .frame(height: 60)
                    
                }.containerRelativeFrame(.horizontal) {
                    length, _ in
                    length * 0.95
                }
                .padding(.all, 5)
                .background(modoPresentacion ? modoOscuro.ventanaFondo : modoClaro.ventanaFondo)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? modoOscuro.colorBordes : modoClaro.colorBordes, lineWidth: 1))
                .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 1)
            }
        }.padding(.all, 5)
            .background(.clear)
            .scrollContentBackground(Visibility.hidden)
            .listRowSpacing(5)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .containerRelativeFrame(.horizontal) {
                length, _ in
                length * 0.65
            }
            .listRowSpacing(20.0)
    }
    
}
