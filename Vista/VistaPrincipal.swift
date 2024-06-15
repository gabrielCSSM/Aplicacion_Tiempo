//
//  VistaPrincipal.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import SwiftUI

struct VistaTiempo: View {
    // Variables de control de interfaz
    @State var modoPresentacion = false
    
    // Variables de control de la modal
    @State var modalAñadirCiudad = false
    @State var modalAltura = PresentationDetent.medium
    
    // Ciudades guardadas
    @ObservedObject var misCiudades: listaCiudades = listaCiudades()
    
    @AppStorage("guardados") var guardados: Data = Data()
    
    @State var eliminarCiudad = false
    
    var body: some View {
        
        VStack {
            
            HStack {
                HStack {
                    Text("Meteo App")
                        .font(.title.bold())
                        .fontDesign(.monospaced)
                        .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                }.frame(alignment: .leading).padding(.trailing, 120)
                
                HStack {
                    if(!misCiudades.listaCiudades.isEmpty) {
                        Button(
                            action: {
                                eliminarCiudad = !eliminarCiudad
                            }, label: {
                                if(eliminarCiudad) {
                                    Image(systemName: "return").foregroundStyle(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                                } else {
                                    Image(systemName: "trash.fill").foregroundStyle(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                                }
                            }
                        )
                    }
                    
                    Button(action: {
                        modoPresentacion = !modoPresentacion
                    }, label: {
                        if(modoPresentacion) {
                            Image(systemName: "sun.horizon.fill").foregroundStyle(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                        } else {
                            Image(systemName: "moon.stars").foregroundStyle(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                        }
                    }
                    )
                }
                .containerRelativeFrame(.horizontal) {
                    length, _ in
                    length * 0.15
                }
                .frame(height: 30)
                .padding(.all, 5)
                .background(modoPresentacion ? temaDark.miniFondo : temaLight.miniFondo)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
                
            }.containerRelativeFrame(.horizontal) {
                length, _ in
                length * 0.90
            }
            /*
             Comprueba de que la lista de ciudades este vacia
             para mostrar el mensaje de abajo
             */
            VStack {
                if misCiudades.listaCiudades.isEmpty {
                    if(!modalAñadirCiudad) {
                        VistaVacia(añadirCiudad: $modalAñadirCiudad, modoPresentacion: $modoPresentacion)
                    }
                } else {
                    VistaConDatos(mostrarModal: $modalAñadirCiudad, eliminarCiudades: $eliminarCiudad, listaCiudades: misCiudades, guardados: guardados, modoPresentacion: $modoPresentacion)
                }
            }.containerRelativeFrame(.horizontal) {
                length, _ in
                length * 0.90
            }.containerRelativeFrame(.vertical) {
                length, _ in
                length * 0.90
            }
            .padding(.all, 5)
            .background(modoPresentacion ? temaDark.colorMainFondo : temaLight.colorMainFondo)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
            .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 20)
            
            /*
             Cuando la condicion de mostrar esta modal
             cambie muestra la modal de abajo
             */
            
            if modalAñadirCiudad {
                VStack{
                    
                }.sheet(isPresented: $modalAñadirCiudad, content: {
                    VistaSeleccionarCiudad(
                        mostrarModal: $modalAñadirCiudad,
                        listaGuardados: misCiudades, modoPresentacion: $modoPresentacion, guardados: guardados)
                    
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
            
        }.frame(maxWidth: .infinity,
                maxHeight:.infinity)
        .background((modoPresentacion ? temaDark.colorFondo : temaLight.colorFondo))
        .onAppear {
            if(!PersistenciaDatos.retrieveData(datos: guardados).isEmpty) {
                misCiudades.listaCiudades = PersistenciaDatos.retrieveData(datos: guardados)
            }
        }
    }
}

struct VistaCiudad: View {
    
    var ciudadEscogida: Ciudad
    @StateObject var modeloCiudad = CiudadModel()
    @State var listaHoras: [tiempoPorHoras] = []
    @Binding var modoPresentacion: Bool
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName:"arrowshape.turn.up.backward.fill")
                }).font(.title2.bold())
                    .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                    .frame(height: 60)
                    .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 10)
                    .frame(alignment: .trailing)
                
                Text(ciudadEscogida.ciudad + ", " + ciudadEscogida.provincia)
                    .font(.title2.bold())
                    .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                    .frame(height: 60)
                    .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 10)
            }
            HStack {
                mostrarDias(modeloCiudad: modeloCiudad, listadoHoras: $listaHoras, modoPresentacion: $modoPresentacion)
                mostrarHoras(listaHoras: $listaHoras, modoPresentacion: $modoPresentacion)
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
        .frame(maxWidth: .infinity)
        .padding(.all, 5)
        .background(modoPresentacion ? temaDark.colorMainFondo : temaLight.colorMainFondo)
        .presentationBackground(.clear)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
        .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 20)
        
        
    }
}

struct mostrarDias: View {
    
    @StateObject var modeloCiudad: CiudadModel
    @Binding var listadoHoras: [tiempoPorHoras]
    @Binding var modoPresentacion: Bool
    
    var body: some View {
        ScrollView(.vertical){
            ForEach(modeloCiudad.meteorologiaDiaria) {
                cosa in
                
                let dia = cosa.dia.split(separator: "-")[2]
                let mes = cosa.dia.split(separator: "-")[1]
                let diaMes: String = dia + " / " + mes
                
                Button(action: {
                    listadoHoras = cosa.horas
                }, label: {
                    Text(diaMes)
                        .font(.headline.italic())
                        .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                        .frame(height: 60)
                })
                .frame(maxWidth: .infinity, alignment: .center)
                .background(modoPresentacion ? temaDark.ventanaFondo : temaLight.ventanaFondo)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
                .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 1)
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
    
    @Binding var listaHoras: [tiempoPorHoras]
    @Binding var modoPresentacion: Bool
    var body: some View {
        ScrollView(.vertical){
            
            ForEach(listaHoras, id: \.id) {
                cosa in
                
                HStack {
                    obtenerIconoTiempo(codigo: cosa.cod_tiempo).scaledToFit()
                        .font(.headline.italic())
                        .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                        .frame(height: 60)
                    
                    Text(cosa.hora + "\n\(round(cosa.temperatura))ºC")
                        .font(.headline.bold())
                        .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                        .frame(height: 60)
                }.containerRelativeFrame(.horizontal) {
                    length, _ in
                    length * 0.95
                }
                .padding(.all, 5)
                .background(modoPresentacion ? temaDark.ventanaFondo : temaLight.ventanaFondo)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
                .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 1)
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

#Preview {
    VistaTiempo()
}
