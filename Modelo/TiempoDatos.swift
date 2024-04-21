//
//  datos.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import Foundation

final class TiempoDatos: ObservableObject {
    
    @Published var tiempo: ModeloTiempo?
     
    let url = URL(
        string:"http://api.openweathermap.org/data/2.5/weather?q=Maceda&appid=71c3e78149e90edcb26b5c8bf57708fa&units=metric&lang=es")
    
    func getTiempo() {
        URLSession.shared.dataTask(with: url!) { datos, resposta, error in
            if let _ = error {
                print("Error")
            }
            
            if let datos = datos,
               let respostaHTTP = resposta as? HTTPURLResponse,
               respostaHTTP.statusCode == 200 {
                let resposta = try! JSONDecoder().decode(ModeloTiempo.self, from: datos)
                print("Tiempo es: \(resposta)")
                DispatchQueue.main.async {
                    self.tiempo = resposta
                }
            }
            
        }.resume()
    }
}
