//
//  VistaPrincipal.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import SwiftUI

struct VistaTiempo: View {
    
    // Variables de control de la modal
    @State var modalAñadirCiudad = false
    @State var modalAltura = PresentationDetent.medium
    
    // Ciudades guardadas
    @ObservedObject var misCiudades: listaCiudades = listaCiudades()
    
    
    
    var body: some View {
        
        VStack {
            // Por motivos de pruebas
            // esto temporalmente esta aqui
            Button(action: {
                misCiudades.listaCiudades = []
            }, label: {
                Text("BORRAR!")
            }).padding(5)
                .background(Color.red)
                .foregroundStyle(Color.white)
            
            /*
             Comprueba de que la lista de ciudades este vacia
             para mostrar el mensaje de abajo
             */
            
            if misCiudades.listaCiudades.isEmpty {
                
                vistaVacia(añadirCiudad: $modalAñadirCiudad)
                
            } else {
                vistaConDatos(mostrarModal: $modalAñadirCiudad, listaCiudades: misCiudades)
            }
            
            /*
             Cuando la condicion de mostrar esta modal
             cambie muestra la modal de abajo
             */
            
            if modalAñadirCiudad {
                VStack{
                    
                }.sheet(isPresented: $modalAñadirCiudad, content: {
                    vistaSeleccionarCiudad(
                        mostrarModal: $modalAñadirCiudad,
                        listaGuardados: misCiudades).presentationDetents([.medium, .large])
                })
            }
            
        }.frame(maxWidth: .infinity, maxHeight:.infinity).background(Color.gray).onAppear(
            perform: {
                //obtenerDatosCiudades()
            })
        
    }//ACABA AQUI
}

struct vistaSeleccionarCiudad: View {
    @Binding var mostrarModal: Bool
    @State var listaGuardados: listaCiudades
    
    var listaProvincias: [String] = devolverProvincias()
    @State var provinciaEscogida: String = "Sin escoger"
    
    @State var mostrarSegundoSelector: Bool = false
    
    @State var listaCiudades: [String] = []
    @State var ciudadEscogida: String = "Sin escoger"
    
    
    var body: some View {
        
        VStack {
            HStack {
                
                Picker("pickerMunicipios", selection: $provinciaEscogida) {
                    
                    Text("Escoger un Municipio")
                    
                    ForEach(listaProvincias, id: \.self) {
                        provincia in
                        Text(provincia).tag(provincia)
                        
                    }
                }.onChange(of: provinciaEscogida) {
                    mostrarSegundoSelector = true
                    listaCiudades = devolverCiudades(provincia: provinciaEscogida)
                }.pickerStyle(.menu)
                
                
                if(mostrarSegundoSelector) {
                    Picker("pickerCiudades", selection: $ciudadEscogida) {
                        Text("Escoger una Ciudad")
                        ForEach(listaCiudades, id: \.self) { ciudad in
                            Text(ciudad).tag(ciudad)
                        }
                    }
                }
            }
            
            Button {
                listaGuardados.añadirCiudad(nombreCiudad: ciudadEscogida, nombreProvincia: provinciaEscogida)
                self.mostrarModal.toggle()
            } label: {
                Text("Guardar")
            }
            
        }.frame(maxWidth: .infinity, maxHeight:.infinity).background(Color.green)
    }
}


struct vistaVacia: View {
    @Binding var añadirCiudad: Bool
    var body: some View {
        Text("No hay ciudades seleccionadas")
        Text("Pulse aqui para añadir una:")
        
        Button(action: {
            añadirCiudad = !añadirCiudad
        }, label: {
            Text("+")
        })
    }
}


struct vistaConDatos: View {
    @Binding var mostrarModal: Bool
    @State var listaCiudades: listaCiudades
    
    var body: some View {
        ForEach(listaCiudades.listaCiudades, id: \.self) {
            ciudad in
            Text(ciudad.ciudad + " / " + ciudad.provincia)
        }
        
        Button(action: {
            mostrarModal = !mostrarModal
        }, label: {
            Text("+")
        })
    
        
        if mostrarModal {
            VStack{
                
            }.sheet(isPresented: $mostrarModal, content: {
                vistaSeleccionarCiudad(mostrarModal: $mostrarModal, listaGuardados: listaCiudades).presentationDetents([.medium, .large])
            })
        }
        
    }
}


#Preview {
    VistaTiempo()
}


func obtenerNumero(_ d: Double) -> String{
    return String(format: "%.0f", d) + " º"
}
