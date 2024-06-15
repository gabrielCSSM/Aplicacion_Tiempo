//
//  VistaConDatos.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 15/6/24.
//

import SwiftUI

struct VistaConDatos: View {
    @Binding var mostrarModal: Bool
    @Binding var eliminarCiudades: Bool
    @State var listaCiudades: listaCiudades
    @State var guardados: Data
    
    @Binding var modoPresentacion: Bool
    
    var body: some View {
        
        NavigationStack{
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(modoPresentacion ? temaDark.colorMainFondo : temaLight.colorMainFondo)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                VStack {
                    ForEach(Array(listaCiudades.listaCiudades.enumerated()), id: \.offset ) {
                        index, ciudad in
                        
                        HStack {
                            
                            if(eliminarCiudades) {
                                Button(action: {
                                    listaCiudades.listaCiudades.remove(at: index)
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
                                .background(modoPresentacion ? temaDark.colorMainFondo : temaLight.colorMainFondo)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
                                .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 20)
                            }
                            
                            
                            
                            NavigationLink(destination: {
                                VistaCiudad(ciudadEscogida: ciudad, modoPresentacion: $modoPresentacion)
                                    .toolbar(.hidden)
                            }, label: {
                                HStack {
                                    VStack(alignment: .leading){
                                        Text(ciudad.provincia)
                                            .font(.subheadline)
                                            .fontDesign(.monospaced)
                                            .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                                        Text(ciudad.ciudad)
                                            .font(.title2.bold())
                                            .fontDesign(.monospaced)
                                            .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                                        
                                    }.containerRelativeFrame(.horizontal) {
                                        length, _ in
                                        length * 0.40
                                    }.padding(.trailing,20)
                                    
                                    Text("\(obtenerDiaActual(formato: "dd/MM"))").font(.title.bold())
                                        .fontDesign(.monospaced)
                                        .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
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
                            .background(modoPresentacion ? temaDark.ventanaFondo : temaLight.ventanaFondo)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
                            .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 20)

                        }
                    }
                    
                    HStack {
                        if(!mostrarModal) {
                            Button(action: {
                                mostrarModal = !mostrarModal
                            }, label: {
                                Text(" + ")
                                    .font(.title3)
                                    .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                                    .padding([.leading, .trailing], 20)
                                    .frame(height: 60)
                                    .background(modoPresentacion ? temaDark.ventanaFondo : temaLight.ventanaFondo)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
                                    .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 10)
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
                                .background(modoPresentacion ? temaDark.colorMainFondo : temaLight.colorMainFondo)
                                .presentationBackground(.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
                                .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 20)
                                
                                
                            })
                        }
                    }
                }
            }
        }.background(modoPresentacion ? temaDark.colorMainFondo : temaLight.colorMainFondo)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
            .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 20)
    }
}

func obtenerDiaActual(formato: String) -> String {
    let formatear = DateFormatter()
    formatear.dateFormat = formato
    if let devolver: String? = formatear.string(from: Date.now) {
        var fecha: String = devolver ?? "No fecha"
        return fecha
    } else {
        return "No fecha"
    }
}
