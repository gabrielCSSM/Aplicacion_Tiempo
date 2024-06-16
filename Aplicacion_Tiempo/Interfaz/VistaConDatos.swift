//
//  VistaConDatos.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 15/6/24.
//

import SwiftUI

struct VistaConDatos: View {
    // Variables de control de la Modal
    @Binding var mostrarModal: Bool
    
    // Variables de control de las Ciudades
    @Binding var eliminarCiudades: Bool
    @State var listaCiudades: ListadoCiudades
    @AppStorage("guardados") var guardados: Data = Data()
    
    // Variables de control de la Interfaz
    @Binding var modoPresentacion: Bool
    
    var body: some View {
        
        NavigationStack{
            
            ZStack {
                // Fondo del "NavigationStack"
                RoundedRectangle(cornerRadius: 20)
                    .fill(modoPresentacion ? modoOscuro.colorMainFondo : modoClaro.colorMainFondo)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                VStack {
                    
                    ForEach(Array(listaCiudades.listaCiudades.enumerated()), id: \.offset ) {
                        index, ciudad in
                        
                        HStack {
                            
                            if(eliminarCiudades) {
                                
                                Button(action: {
                                    
                                    listaCiudades.listaCiudades.remove(at: index)
                                    guardados = Data()
                                    guardados = PersistenciaDatos.GuardarDatos(listado: listaCiudades.listaCiudades)
                                    
                                }, label: {
                                    
                                    HStack {
                                        
                                        Image(systemName: "x.circle").foregroundStyle( .red)
                                        
                                    }
                                })
                                .buttonStyle(PlainButtonStyle())
                                .containerRelativeFrame(.horizontal) {
                                    length, _ in
                                    length * 0.10
                                }.containerRelativeFrame(.vertical) {
                                    length, _ in
                                    length * 0.07
                                }
                                .padding(.all, 5)
                                .background(modoPresentacion ? modoOscuro.colorMainFondo : modoClaro.colorMainFondo)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? modoOscuro.colorBordes : modoClaro.colorBordes, lineWidth: 1))
                                .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 20)
                            }
                            
                            // Link el cual nos lleva a la vista propia de la Ciudad
                            NavigationLink(destination: {
                                
                                VistaCiudad(ciudadEscogida: ciudad, modoPresentacion: $modoPresentacion)
                                    .toolbar(.hidden)
                                
                            }, label: {
                                
                                HStack {
                                    
                                    VStack(alignment: .leading){
                                        
                                        Text(ciudad.provincia)
                                            .font(.subheadline)
                                            .fontDesign(.monospaced)
                                            .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                                        
                                        Text(ciudad.ciudad)
                                            .font(.title2.bold())
                                            .fontDesign(.monospaced)
                                            .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                                        
                                    }.containerRelativeFrame(.horizontal) {
                                        length, _ in
                                        length * 0.40
                                    }.padding(.trailing,20)
                                    
                                    Text("\(ObtenerDiaActual(formato: "dd/MM"))").font(.title.bold())
                                        .fontDesign(.monospaced)
                                        .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                                        .padding(.leading,10)
                                }
                            }).containerRelativeFrame(.horizontal) {
                                length, _ in
                                length * 0.80
                            }.containerRelativeFrame(.vertical) {
                                length, _ in
                                length * 0.10
                            }
                            .padding(.all, 5)
                            .background(modoPresentacion ? modoOscuro.ventanaFondo : modoClaro.ventanaFondo)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? modoOscuro.colorBordes : modoClaro.colorBordes, lineWidth: 1))
                            .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 20)

                        }
                    }
                    
                    HStack {
                        
                        if(!mostrarModal) {
                            
                            Button(action: {
                                
                                mostrarModal = !mostrarModal
                                
                            }, label: {
                                Text(" + ")
                                    .font(.title3)
                                    .foregroundColor(modoPresentacion ? modoOscuro.colorLetra : modoClaro.colorLetra)
                                    .padding([.leading, .trailing], 20)
                                    .frame(height: 60)
                                    .background(modoPresentacion ? modoOscuro.ventanaFondo : modoClaro.ventanaFondo)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(modoPresentacion ? modoOscuro.colorBordes : modoClaro.colorBordes, lineWidth: 1))
                                    .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 10)
                                    .padding(.bottom, 5)
                            })
                            
                        } else {
                            
                            VStack{
                                
                            }.sheet(isPresented: $mostrarModal, content: {
                                
                                VistaSeleccionarCiudad(
                                    mostrarModal: $mostrarModal,
                                    listaGuardados: listaCiudades, modoPresentacion: $modoPresentacion, guardados: guardados)
                                
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
                                
                                
                            })
                        }
                    }
                }
            }
        }.background(modoPresentacion ? modoOscuro.colorMainFondo : modoClaro.colorMainFondo)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? modoOscuro.colorBordes : modoClaro.colorBordes, lineWidth: 1))
            .shadow(color: modoPresentacion ? modoOscuro.colorSombra : modoClaro.colorSombra, radius: 20)
    }
}

// Pequeña funcion la cual nos devuelve el dia actual
func ObtenerDiaActual(formato: String) -> String {
    let formatear = DateFormatter()
    formatear.dateFormat = formato
    if let devolver: String? = formatear.string(from: Date.now) {
        var fecha: String = devolver ?? "No fecha"
        return fecha
    } else {
        return "No fecha"
    }
}
