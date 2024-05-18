//
//  Vsita.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import SwiftUI

struct VistaTiempo: View {
    
    //Variables
    
    // Control para mostrar los controles
    // para añadir una ciudad
    @State var modalAñadirCiudad = false
    
    @State var modalAltura = PresentationDetent.medium
    
    
    // toDo
    @StateObject var tiempo: TiempoDatos = TiempoDatos()
    
    // Array que tiene las
    // ciudades guardadas por el usuario
    var arrayTiempo: [String] = []
    
    var body: some View {
            
        /*
         Comprueba de que la lista de ciudades este vacia
         para mostrar el mensaje de abajo
        */
        
        if arrayTiempo.isEmpty {
            Text("No hay ciudades seleccionadas")
            Text("Pulse aqui para añadir una:")
            Button(action: {
                modalAñadirCiudad = !modalAñadirCiudad
            }, label: {
                Text("+")
            })
        }
        
        /* 
         Cuando la condicion de mostrar esta modal
         cambie muestra la modal de abajo
        */
        
        if modalAñadirCiudad {
            VStack{
            }.sheet(isPresented: $modalAñadirCiudad,
            content: {
                VistaSelector()            .presentationDetents([.medium, .large])
                    .toolbar(content: {
                        Button(action: {
                            modalAñadirCiudad = !modalAñadirCiudad
                        }, label: {
                            Text("X")
                        })
                    })
            })
        }
        //ACABA AQUI
    }
}

#Preview {
    VistaTiempo()
}

func obtenerNumero(_ d: Double) -> String{
    return String(format: "%.0f", d) + " º"
}
