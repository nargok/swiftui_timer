//
//  ContentView.swift
//  MyTimer
//
//  Created by 後閑諒一 on 2021/04/25.
//

import SwiftUI

struct ContentView: View{
    
    @State var timerHandler: Timer?
    @State var count = 0
    
    @AppStorage("timer_value") var  timerValue = 10
    
    @State var showAlert = false
    @State var showReset = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("backgroundTimer")
                    .resizable()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                
                VStack(spacing: 30.0) {
                    Text("残り\(timerValue - count)秒")
                        .font(.largeTitle)
                    
                    HStack {
                        // Start Button
                        Button(action: {
                            showReset = false
                            startTimer()
                        }) {
                            Text("START")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color("startColor"))
                                .clipShape(Circle())
                            
                        }
                        
                        // Stop Button
                        Button(action: {
                            showReset = true
                            if let unwrapedTimerHandler = timerHandler {
                                if unwrapedTimerHandler.isValid == true {
                                    unwrapedTimerHandler.invalidate()
                                }
                            }
                        }) {
                            Text("STOP")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color("stopColor"))
                                .clipShape(Circle())
                            
                        }
                    }
                    
                    Button(action: {
                        count = 0
                    }) {
                        Text("リセット")
                            .opacity(showReset ? 1 : 0)
                    }
                }
            }
            // 画面が描画されたときに実行される
            .onAppear {
                count = 0
            }
            .navigationBarItems(trailing:
                                    NavigationLink(
                                        destination: SettingView()) {
                                        Text("秒数設定")
                                    }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("終了"),
                      message: Text("タイマー終了時間です"),
                      dismissButton: .default(Text("OK")))
            }
        }
        
    }
    
    func countDownTimer() {
        count += 1
        
        if timerValue - count <= 0 {
            timerHandler?.invalidate()
            
            showAlert = true
        }
    }
    
    func startTimer() {
        if let unwrapedTimerHandler = timerHandler {
            // タイマーが実行中だったらスタートしない
            if unwrapedTimerHandler.isValid == true {
                return
            }
        }
        
        if timerValue - count <= 0 {
            count = 0
        }
        
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            countDownTimer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
