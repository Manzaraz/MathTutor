//
//  ContentView.swift
//  MathTutor
//
//  Created by Christian Manzaraz on 29/01/2025.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @FocusState private var textFieldIsFocused: Bool
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    @State private var answer = ""
    @State private var audioPlayer: AVAudioPlayer!
    @State private var textFieldIsDisabled = false
    @State private var guessButtonDisabled = false
    @State private var message = ""
    
    private var emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    var body: some View {
        VStack {
            Group {
                Text("\(firstNumberEmojis)")
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                Text("+")
                    .font(.system(size: 40))
                Text("\(secondNumberEmojis)")
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
            
            
            Spacer()
            
            Text("\(firstNumber) + \(secondNumber) =")
                .font(.largeTitle)
                    
            TextField("", text: $answer)
                .font(.system(.largeTitle, weight: .bold))
                .textFieldStyle(.roundedBorder)
                .frame(width: 60)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .focused($textFieldIsFocused)
                .disabled(textFieldIsDisabled)
                .textContentType(.oneTimeCode) // to avoid the "AUTO FILL" tag appears
            
            Button("Guess") {
                textFieldIsFocused = false
                
                let result = firstNumber + secondNumber
                if let answerValue = Int(answer) {
                    if answerValue == result {
                        playSound(soundName: "correct")
                        message = "Correct!"
                    } else {
                        playSound(soundName: "wrong")
                        message = "Sorry, The Correct Answer is \(result)!"
                    }
                } else {
                    playSound(soundName: "worng")
                    message = "Sorry, The Correct Answer is \(result)!"
                }
                textFieldIsDisabled = true
                guessButtonDisabled = true
//                answer = ""
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || guessButtonDisabled)
                        
            Spacer()
            
            Text(message)
                .font(.system(.largeTitle, weight: .black))
                .multilineTextAlignment(.center)
                .foregroundStyle(message == "Correct!" ? .green : .red)
            
            if guessButtonDisabled {
                Button("Play Again?") {
                    answer = ""
                    message = ""
                    guessButtonDisabled = false
                    textFieldIsDisabled = false
                    generateNewEquation()
                }
                .foregroundStyle(Color.accentColor)
                
            }
            
            Spacer()
            
        }
        .padding()
        .onAppear {
            generateNewEquation()
        }
        
    }
    
    
    func generateNewEquation() {
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        firstNumberEmojis = String(repeating: emojis.randomElement()!, count: firstNumber)
        secondNumberEmojis = String(repeating: emojis.randomElement()!, count: secondNumber)
    }
        
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("🤬ERROR: Couldn't read the file named \(soundName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡ERROR: \(error.localizedDescription) playing audioPlayer")
        }
    }
}

#Preview {
    ContentView()
}
