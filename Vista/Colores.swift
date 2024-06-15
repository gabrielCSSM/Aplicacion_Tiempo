//
//  Colores.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 13/6/24.
//

import Foundation
import SwiftUI

struct temaLight: ShapeStyle {
    
    static var colorFondo: LinearGradient = LinearGradient(colors: [.blue.opacity(0.80), .white], startPoint: .top, endPoint: .bottom)
    static var colorMainFondo: LinearGradient = LinearGradient(colors: [.blue.opacity(0.50), .white], startPoint: .top, endPoint: .bottom)
    
    static var colorBordes: Color = .gray
    static var colorSombra: Color = .gray.opacity(1.75)
    static var colorLetra: Color = .black
    
    static var ventanaFondo: LinearGradient = LinearGradient(colors: [.gray.opacity(0.5), .white], startPoint: .top, endPoint: .bottom)
    static var miniFondo: LinearGradient = LinearGradient(colors: [.white, .black.opacity(0.40)], startPoint: .top, endPoint: .bottom)
    
    static var interiorBoton: Color = .white
    static var letraBoton: Color = .blue.opacity(0.75)
    static var exteriorBoton: Color = .blue.opacity(0.75)
}

struct temaDark: ShapeStyle{
    
    static var colorFondo: LinearGradient = LinearGradient(colors: [.black, .blue.opacity(1.5)], startPoint: .top, endPoint: .bottom)
    static var colorMainFondo: LinearGradient = LinearGradient(colors: [.black.opacity(0.60), .blue.opacity(1.5)], startPoint: .top, endPoint: .bottom)
    
    static var colorBordes: Color = .white
    static var colorSombra: Color = .white.opacity(0.75)
    static var colorLetra: Color = .white
    
    static var ventanaFondo: LinearGradient = LinearGradient(colors: [.gray.opacity(0.50), .black.opacity(0.75)], startPoint: .top, endPoint: .bottom)
    static var miniFondo: LinearGradient = LinearGradient(colors: [.yellow, .gray.opacity(0.75)], startPoint: .top, endPoint: .bottom)
    
    static var interiorBoton: Color = .black
    static var letraBoton: Color = .red.opacity(0.75)
    static var exteriorBoton: Color = .red.opacity(0.75)
}
