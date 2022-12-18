//
//  ContentView.swift
//  MultiTable
//
//  Created by Andrey Matviets on 14.12.2022.
//

import SwiftUI

struct Question {
    var textToShow: String
    var correctAnswer: Int
}

// struct to create second view with a check of an answer
struct SecondView: View {
    let isAnswerCorrect: String
    let scoreIs: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("Check answer view")
        Button("hide") {
            dismiss()
        }
        
    }
}

struct ContentView: View {
    @State private var digitOne = 2
    @State private var userAnswer = 0
    @State private var isAnswerCorrect = ""
    @State private var selectedAmountQuestions = 5
    @State private var questionsCounter = 0
    @State private var showAlert = false
    @FocusState private var answerIsFocused: Bool
    @State private var randomElement = Int.random(in: 1...12)
    @AppStorage ("score") private var score = 0
    // replaced by @AppStorage to save users score
//    @State private var score = 0
    
    // to show a sheet we need @State
    @State private var showingSheet = false
    
    @State private var arrayOfQuestions = []
    @State private var tapCountForArray = 0
    
    var questionsArray = [5, 10, 20]
   
    
 

    var body: some View {
        NavigationView {
            
            VStack {
                Form {
                    Section {
                        Stepper("choose digit  -  \" \(digitOne) \" ", value: $digitOne, in: 2...12, step: 1)
                    }
                    Section {
                        Picker("amount of questions", selection: $selectedAmountQuestions) {
                            ForEach(questionsArray, id: \.self) {
                                Text("\($0)")
                            }

                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text("Choose amount of questions")
                    }
                    
                    Section {
                        HStack {
                            Text("\(digitOne) x \(randomElement) = ")
                            TextField("Your_answer", value: $userAnswer, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .background(.secondary)
                                .keyboardType(.decimalPad)
                                .focused($answerIsFocused)
                        }
                    } header: {
                        Text("Enter you answer for multiplication")
                    }
                    
                
                    Section {
                        HStack (spacing: 50){
                            VStack {
                                Text("Your answer")
                                Text(userAnswer == 0 ? "Enter you answer" : "\(isAnswerCorrect)")
                                    .foregroundColor(userAnswer == 0 ? .red : .primary)
                            }
                            
                            VStack {
                                Text("Your score")
                                Text("\(score)")
                            }
                        }
                        
                        
                        HStack (alignment: .center, spacing: 70) {
                            Button("CheckAnswer") {
                                checkAnswer()
                                showingSheet.toggle()
                            }
                                .frame(width: 115, height: 40)
                                .background(.blue)
                                .foregroundColor(.white)
                                .buttonBorderShape(.roundedRectangle(radius: 20))
                                .sheet(isPresented: $showingSheet) {
                                    SecondView(
                                        isAnswerCorrect: (userAnswer == 0 ? "Enter you answer" : "\(isAnswerCorrect)"),
                                        scoreIs: "Score is \(score)")
                                }
                            Button("NextQuestion", action: askQuestion)
                                .frame(width: 115, height: 40)
                                .background(.blue)
                                .foregroundColor(.white)
                                .buttonBorderShape(.roundedRectangle(radius: 20))
                        }

                    } header: {
                        Text("Results")
                    }
                    Text("Array text ")
                    
                }
            }
            .navigationTitle("MultiplePractise")
            .alert("StarNewGame", isPresented: $showAlert) {
                Button("NewGame", action: newGame)
            } message: {
                Text("You've finished \(selectedAmountQuestions)")
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        answerIsFocused = false
                        checkAnswer()
                    }
                }
            }
        }
        .onAppear(perform: {
            generatedQuestions()
            print(arrayOfQuestions)
        })
        .onChange(of: digitOne) { newValue in
            arrayOfQuestions = []
            generatedQuestions()
            print(arrayOfQuestions)
        }
    }
    
    func checkAnswer() {
        if userAnswer == digitOne * randomElement {
            isAnswerCorrect = "Wright"
            score += 1
        } else {
            isAnswerCorrect = "Wrong"
        }
        if questionsCounter < selectedAmountQuestions-1 {
            questionsCounter += 1
           
        } else {
            showAlert = true
        }
    }
    
    func newGame() {
        isAnswerCorrect = ""
        selectedAmountQuestions = 5
        questionsCounter = 0
        score = 0
        showAlert = false
    }
    
    func askQuestion() {
        randomElement = Int.random(in: 1...12)
        isAnswerCorrect = ""
        userAnswer = 0
    }
    
    func generatedQuestions() {
        for question in 1..<13 {
            let generatedQuestion = (Question(textToShow: "\(question). What is \(digitOne) x \(question)", correctAnswer: digitOne * question))
        arrayOfQuestions.append(generatedQuestion)
        }
        
        //some code to generate
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
