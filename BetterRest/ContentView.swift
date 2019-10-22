//
//  ContentView.swift
//  BetterRest
//
//  Created by Luc Derosne on 20/10/2019.
//  Copyright © 2019 Luc Derosne. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var recommendedTimeToSleep = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Heure souhaitée du réveil")) {
                        DatePicker("SVP entrez un horaire", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    Section(header: Text("Quantité de sommeil désirée")) {
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") heures")
                        }
                    }
                    Section(header: Text("Nombre de café par jour")) {
                        Picker(selection: $coffeeAmount, label: Text("Saisir le nombre de tasse")) {
                            ForEach(1...20, id: \.self) { num in
                                num == 1 ? Text("\(num) tasse") : Text("\(num) tasses")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .labelsHidden()
                    }
                }
                .navigationBarTitle(Text("BettterRest =>   \(calculateRecommandedtimeSleep())"))
            }
        }
    }
    
    func calculateRecommandedtimeSleep() -> String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let timeToBed = formatter.string(from: sleepTime)
            return timeToBed
            //           alertMessage = formatter.string(from: sleepTime)
            //           alertTitle = "Your ideal bedtime is…"
            
        } catch {
            return "erreur"
            //           alertTitle = "Erreur"
            //           alertMessage = "Désolé, il y a un probléme pour calculer votre heure de coucher."
        }
        //showingAlert = true
    }
    
    //    func calculateBedtime() {
    //        let model = SleepCalculator()
    //        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
    //        let hour = (components.hour ?? 0) * 60 * 60
    //        let minute = (components.minute ?? 0) * 60
    //
    //        do {
    //            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
    //            let sleepTime = wakeUp - prediction.actualSleep
    //
    //            let formatter = DateFormatter()
    //            formatter.timeStyle = .short
    //
    //            alertMessage = formatter.string(from: sleepTime)
    //            alertTitle = "Your ideal bedtime is…"
    //        } catch {
    //            alertTitle = "Error"
    //            alertMessage = "Sorry, there was a problem calculating your bedtime."
    //        }
    //
    //        showingAlert = true
    //    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
