//
//  VistaPrincipal.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import SwiftUI

struct VistaPrincipal: View {
    
    // Variables de control de interfaz
    @State var modoPresentacion = false
    
    // Variables de control de la modal
    @State var modalAñadirCiudad = false
    @State var modalAltura = PresentationDetent.medium
    
    // Variables de control de la Ciudades
    @ObservedObject var ciudades: ListadoCiudades = ListadoCiudades()
    @AppStorage("guardados") var guardados: Data = Data()
    @State var eliminarCiudad = false
    
    var body: some View {
        
        VStack {
            // Parte superior (Titulo y Botones)
            HStack {
                // Titulo
                HStack {
                    
                    Text("Meteo App")
                        .font(.title.bold())
                        .fontDesign(.monospaced)
                        .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                }
                .frame(alignment: .leading).padding(.trailing, 120)
                
                // Botones (Eliminar)
                HStack {
                    
                    if(!ciudades.listaCiudades.isEmpty) {
                        
                        Button(
                            action: {
                                
                                eliminarCiudad = !eliminarCiudad
                                
                            }, label: {
                                
                                if(eliminarCiudad) {
                                    
                                    Image(systemName: "return").foregroundStyle(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                                    
                                } else {
                                    
                                    Image(systemName: "trash.fill").foregroundStyle(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                                    
                                }
                            }
                        )
                    }
                    
                    // Botones (Presentacion)
                    Button(action: {
                        
                        modoPresentacion = !modoPresentacion
                        
                    }, label: {
                        
                        if(modoPresentacion) {
                            
                            Image(systemName: "sun.horizon.fill").foregroundStyle(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                            
                        } else {
                            
                            Image(systemName: "moon.stars").foregroundStyle(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                            
                        }
                    })
                }
                .containerRelativeFrame(.horizontal) {
                    length, _ in
                    length * 0.15
                }
                .frame(height: 30)
                .padding(.all, 5)
                .background(modoPresentacion ? modoOscuro.miniFondo : modoClaro.miniFondo)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? modoOscuro.colorBordes : modoClaro.colorBordes, lineWidth: 1))
                
            }.containerRelativeFrame(.horizontal) {
                length, _ in
                length * 0.90
            }
            
            // Interfaz principal
            
            /*
             Comprueba de que la lista de ciudades este vacia
             para mostrar el mensaje de abajo
             */
            VStack {
                
                if ciudades.listaCiudades.isEmpty {
                    
                    if(!modalAñadirCiudad) {
                        
                        VistaVacia(añadirCiudad: $modalAñadirCiudad,                      modoPresentacion: $modoPresentacion
                        )
                        
                    }
                } else {
                
                    VistaConDatos(mostrarModal: $modalAñadirCiudad,                          eliminarCiudades: $eliminarCiudad,
                                  listaCiudades: ciudades,
                                  guardados: guardados,
                                  modoPresentacion: $modoPresentacion)
                }
                
            }.containerRelativeFrame(.horizontal) {
                length, _ in
                length * 0.90
            }.containerRelativeFrame(.vertical) {
                length, _ in
                length * 0.90
            }
            .padding(.all, 5)
            .background(modoPresentacion ? modoOscuro.colorMainFondo : modoClaro.colorMainFondo)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? modoOscuro.colorBordes : modoClaro.colorBordes, lineWidth: 1))
            .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 20)
            
            
            
            // Cuando se presione el boton, se muestra
            // la ventana modal la cual nos permitira añadir una
            // ciudad
            
            if modalAñadirCiudad {
                
                VStack{
                    
                }.sheet(isPresented: $modalAñadirCiudad, 
                        content: {
                            VistaSeleccionarCiudad(
                                mostrarModal: $modalAñadirCiudad,
                                listaGuardados: ciudades, 
                                modoPresentacion: $modoPresentacion,
                                guardados: guardados
                            )
                            .presentationDetents([.fraction(0.4)])
                            .containerRelativeFrame(.horizontal) {
                                length, _ in
                                length * 0.90
                            }
                            .containerRelativeFrame(.vertical) {
                                length, _ in
                                length * 0.90
                            }
                            .padding(.all, 5)
                            .background(modoPresentacion ? modoOscuro.colorMainFondo : modoClaro.colorMainFondo)
                            .presentationBackground(.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? modoOscuro.colorBordes : modoClaro.colorBordes, lineWidth: 1))
                            .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 20)
                        }
                    )
            }
        }.frame(maxWidth: .infinity,
                maxHeight:.infinity)
        .background((modoPresentacion ? modoOscuro.colorFondo : modoClaro.colorFondo))
        .onAppear {
            // Cuando se cargue la vista, en caso de que
            // haya datos se mostrarian esos datos
            if(!PersistenciaDatos.DevolverDatos(datos: guardados).isEmpty) {
                ciudades.listaCiudades = PersistenciaDatos.DevolverDatos(datos: guardados)
            }
        }
    }
}

#Preview {
    VistaPrincipal()
}
