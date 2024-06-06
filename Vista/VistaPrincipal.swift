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
    @ObservedObject var ciudades: listaCiudades = listaCiudades()
    
    var body: some View {
        VStack {
            
            // Por motivos de pruebas
            // esto temporalmente esta aqui
            Button(action: {
                ciudades.listaCiudades = []
            }, label: {
                Text("BORRAR!")
            }).padding(5)
                .background(Color.red)
                .foregroundStyle(Color.white)
            
            /*
             Comprueba de que la lista de ciudades este vacia
             para mostrar el mensaje de abajo
             */
            
            if ciudades.listaCiudades.isEmpty {
                
                vistaVacia(añadirCiudad: $modalAñadirCiudad)
                
            } else {
                vistaConDatos(listaCiudades: ciudades.listaCiudades)
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
                        lista: ciudades).presentationDetents([.medium, .large])
                })
            }
            
        }.frame(maxWidth: .infinity, maxHeight:.infinity).background(Color.gray).onAppear(
            perform: {
           llamarAPI()
        })
        
        }//ACABA AQUI
}

struct vistaSeleccionarCiudad: View {
    @Binding var mostrarModal: Bool
    @State var lista: listaCiudades
    @State var nombreProvincia: String = ""
    @State var nombreCiudad: String = ""
    
    var body: some View {
        
        VStack {
            
            Text("Introduce el nombre de la provincia:")
            TextField("Hola", text: $nombreProvincia)
            
            Text("Introduce el nombre de la municipio")
            TextField("Hola", text: $nombreCiudad)
            
            Button {
                lista.añadirCiudad(provincia: nombreProvincia, municipio: nombreCiudad)
                self.mostrarModal.toggle()
            } label: {
                Text("Guardar")
            }
            
        }.frame(maxWidth: .infinity, maxHeight:.infinity).background(Color.indigo)
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
    var listaCiudades: [ciudad] = []
    var body: some View {
        ForEach(listaCiudades, id: \.self) {
            ciudad in
            Text(ciudad.nombreCiudad + " / " + ciudad.nombreMunicipio)
        }
    }
}




#Preview {
    VistaTiempo()
}


func obtenerNumero(_ d: Double) -> String{
    return String(format: "%.0f", d) + " º"
}
