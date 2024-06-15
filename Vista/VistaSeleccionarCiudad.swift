//
//  VistaSeleccionarCiudad.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 15/6/24.
//

import SwiftUI

struct VistaSeleccionarCiudad: View {
    
    @Binding var mostrarModal: Bool
    @State var listaGuardados: listaCiudades
    @Binding var modoPresentacion: Bool
    
    var listaProvincias: [String] = devolverProvincias()
    @State var provinciaEscogida: String = ""
    
    @State var mostrarSegundoSelector: Bool = false
    
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
                    .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                
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
                        listaCiudades = devolverCiudades(provincia: provinciaEscogida)
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
                .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 20)
            
            
            HStack {
                if(mostrarSegundoSelector) {
                    Text("Escoger una Ciudad")
                        .font(.subheadline)
                        .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                    
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
                .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 20)
            
            
            if(errorEnProvincia) {
                Text("No hay provincia seleccionada")
            }
            if(errorEnCiudad) {
                Text("No hay ciudad seleccionada")
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
                    
                    guardados = PersistenciaDatos.saveData(listado: listaGuardados.listaCiudades)
                    
                    print(listaGuardados.listaCiudades)
                    
                    self.mostrarModal.toggle()
                }
            } label: {
                Text("Guardar")
            }
        }.padding(.all, 5)
    }
}
