//
//  VistaVacia.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 15/6/24.
//

import SwiftUI

struct VistaVacia: View {
    @Binding var añadirCiudad: Bool
    @Binding var modoPresentacion: Bool
    var body: some View {
        
        
        
        Button(action: {
            añadirCiudad = !añadirCiudad
        }, label: {
            Text("No hay ciudades seleccionadas \n Pulse aqui para añadir una.")
                .font(.title3)
                .foregroundColor(modoPresentacion ? temaDark.colorLetra : temaLight.colorLetra)
                .padding([.leading, .trailing], 20)
                .frame(height: 100)
                .background(modoPresentacion ? temaDark.ventanaFondo : temaLight.ventanaFondo)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(modoPresentacion ? temaDark.colorBordes : temaLight.colorBordes, lineWidth: 1))
                .shadow(color: modoPresentacion ? temaDark.colorSombra : temaLight.colorSombra, radius: 10)
        })
    }
}
