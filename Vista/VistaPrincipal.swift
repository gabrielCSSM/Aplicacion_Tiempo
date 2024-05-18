//
//  VistaPrincipal.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import SwiftUI

struct VistaTiempo: View {
    
    //Variables
    
    // Para controlar la modal para añadir una nueva ciudad
    @State var modalAñadirCiudad = false
    @State var modalAltura = PresentationDetent.medium
    
    // toDo timidin
    @StateObject var tiempo: TiempoDatos = TiempoDatos()
    
    // Ciudades guardadas
    @ObservedObject var ciudades: misCiudades = misCiudades()
    
    var body: some View {
        
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
            
            Text("No hay ciudades seleccionadas")
            Text("Pulse aqui para añadir una:")
            
            Button(action: {
                modalAñadirCiudad = !modalAñadirCiudad
            }, label: {
                Text("+")
            })
            
        } else {
            ForEach(ciudades.listaCiudades, id: \.self) {
                ciudad in
                Text(ciudad.nombre + " / " + ciudad.municipio)
            }
            
        }
        
        /* 
         Cuando la condicion de mostrar esta modal
         cambie muestra la modal de abajo
        */
        
        if modalAñadirCiudad {
            
            VStack{}.sheet(
                isPresented: $modalAñadirCiudad,
                content: {
                    modalSelectorCiudad(
                        mostrarModal: $modalAñadirCiudad,
                        lista: ciudades)    .presentationDetents([.medium, .large])
                })
            
        }//ACABA AQUI
    }
}

struct modalSelectorCiudad: View {
    @Binding var mostrarModal: Bool
    @State var lista: misCiudades
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

        }
        .padding()
    }
}


#Preview {
    VistaTiempo()
}


func obtenerNumero(_ d: Double) -> String{
    return String(format: "%.0f", d) + " º"
}
