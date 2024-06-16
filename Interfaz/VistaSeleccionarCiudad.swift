//
//  VistaSeleccionarCiudad.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 15/6/24.
//

import SwiftUI

struct VistaSeleccionarCiudad: View {
    
    // Variables de control de la Interfaz
    @Binding var mostrarModal: Bool
    @State var listaGuardados: ListadoCiudades
    @Binding var modoPresentacion: Bool
    
    var listaProvincias: [String] = DevolverProvincias()
    @State var provinciaEscogida: String = ""
    
    @State var mostrarSegundoSelector: Bool = false
    
    // Variables de control de las Ciudades
    @State var listaCiudades: [String] = []
    @State var ciudadEscogida: String = ""
    
    @State var errorEnProvincia = false
    @State var errorEnCiudad = false
    @State var guardados: Data
    
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text("Seleccionar provincia")
                    .font(.subheadline)
                    .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                
                Picker("pickerProvincias", selection: $provinciaEscogida) {
                    
                    Text("- Escoger -")
                    
                    ForEach(listaProvincias, id: \.self) {
                        provincia in
                        Text(provincia).tag(provincia)
                        
                    }
                    
                }.onChange(of: provinciaEscogida) {
                    
                    if(!provinciaEscogida.isEmpty) {
                        
                        errorEnProvincia = false
                        mostrarSegundoSelector = true
                        listaCiudades = DevolverCiudades(provincia: provinciaEscogida)
                        
                    } else {
                        
                        errorEnProvincia = true
                        
                    }
                }.pickerStyle(.menu)
                 .containerRelativeFrame(.horizontal) {
                        length, _ in
                        length * 0.45
                 }
                
            }.containerRelativeFrame(.horizontal) {
                length, _ in
                length * 0.85
            }.frame(height:60)
                .padding(.all, 5)
                .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 20)
            
            HStack {
                
                if(mostrarSegundoSelector) {
                    
                    Text("Escoger una Ciudad")
                        .font(.subheadline)
                        .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                    
                    Picker("pickerCiudades", selection: $ciudadEscogida) {
                        
                        Text("- Escoger -")
                        
                        ForEach(listaCiudades, id: \.self) { ciudad in
                            Text(ciudad).tag(ciudad)
                                
                        }
                        
                    }.pickerStyle(.menu)
                     .containerRelativeFrame(.horizontal) {
                            length, _ in
                            length * 0.45
                     }
                }
            }.containerRelativeFrame(.horizontal) {
                length, _ in
                length * 0.85
            }.frame(height:60)
                .padding(.all, 5)
                .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 20)
            
            
            // Mensaje que nos saltaria si intentamos guardar,
            // sin seleccionar provincia
            if(errorEnProvincia) {
                Text("No hay provincia seleccionada")
                    .font(.headline.bold())
                    .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
            }
            
            // Mensaje que nos saltaria si intentamos guardar,
            // sin seleccionar ciudad
            if(errorEnCiudad) {
                Text("No hay ciudad seleccionada")
                    .font(.headline.bold())
                    .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
            }
            
            Button {
                
                if(provinciaEscogida.isEmpty) {
                    errorEnProvincia = true
                } else {
                    errorEnProvincia = false
                    if(ciudadEscogida.isEmpty) {
                        errorEnCiudad = true
                    }
                }
                
                if(!ciudadEscogida.isEmpty && !provinciaEscogida.isEmpty) {
                    
                    errorEnCiudad = false
                    
                    listaGuardados.añadirCiudad(nombreCiudad: ciudadEscogida, nombreProvincia: provinciaEscogida)
                    
                    guardados = PersistenciaDatos.GuardarDatos(listado: listaGuardados.listaCiudades)
                    
                    self.mostrarModal.toggle()
                }
            } label: {
                Text("Guardar").font(.headline.bold())
                    .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
            }
        }.padding(.all, 5)
    }
}
