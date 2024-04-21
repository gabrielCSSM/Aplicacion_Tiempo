//
//  Vsita.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import SwiftUI

struct VistaTiempo: View {
    
    @StateObject var tiempo: TiempoDatos = TiempoDatos()
    
    var body: some View {
        VStack {
            //CIUDAD
            Text("\(tiempo.tiempo?.cidade ?? "Ciudad Desconocida")")
                .foregroundStyle(Color.white)
                .font(.title)
            
            ForEach(tiempo.tiempo?.tiempo ?? []) {
                data in
                //TIEMPO ACTUAL
                Text("\(data.descricion)")
                    .foregroundStyle(Color.white)
                    .font(.title3)
                HStack{
                    //TEMPERATURA ACTUAL
                    AsyncImage(url: URL(string: "http://openweathermap.org/img/wn/\(data.icono)@2x.png"))
                    Text(obtenerNumero(tiempo.tiempo?.temperatura.temperaturaActual ?? 0))
                        .foregroundStyle(Color.white)
                        .font(.title)
                }
            }
    
            
            HStack {
                //TEMPERATURA MAXIMA
                Image(systemName: "thermometer.sun.fill")
                    .symbolRenderingMode(.multicolor)
                Text(obtenerNumero(tiempo.tiempo?.temperatura.temperaturaMax ?? 0)).foregroundStyle(Color.white)
                    .font(.title3)
                
                //TEMPERATURA MINIMA
                Image(systemName: "thermometer.snowflake")
                    .symbolRenderingMode(.multicolor)
                Text(obtenerNumero(tiempo.tiempo?.temperatura.temperaturaMin ?? 0)).foregroundStyle(Color.white)
                    .font(.title3)
            }.padding()
            
            
            HStack {
                //HUMEDAD
                Image(systemName: "humidity.fill")
                    .foregroundStyle(Color.white)
                Text("\(tiempo.tiempo?.temperatura.humidade ?? 0) %").foregroundStyle(Color.white)
                    .font(.title3)
            }.padding()
            
            HStack {
                //PRESION ATMOSFERICA
                Image(systemName: "hurricane")
                    .foregroundStyle(Color.white)
                Text("\(tiempo.tiempo?.temperatura.presion ?? 0)  hPa").foregroundStyle(Color.white)
                    .font(.title3)
            }.padding()
            
            Spacer()
            
        }.onAppear{
            tiempo.getTiempo()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
         .background(LinearGradient(
            gradient: Gradient(colors: [.blue, .purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
         )
    }
}

#Preview {
    VistaTiempo()
}

func obtenerNumero(_ d: Double) -> String{
    return String(format: "%.0f", d) + " º"
}
