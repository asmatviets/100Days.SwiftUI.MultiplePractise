//
//  ContentView.swift
//  MultiTable
//
//  Created by Andrey Matviets on 14.12.2022.
//

import SwiftUI

//struct Question {
//    var textToShow: String
//    var correctAnswer: Int
//}

// struct to create second view with a check of an answer
//struct SecondView: View {
//    let isAnswerCorrect: String
//    let scoreIs: String
//    @Environment(\.dismiss) var dismiss
//
//    var body: some View {
//        Text("Check answer view")
//        Button("hide") {
//            dismiss()
//        }
//
//    }
//}

struct ContentView: View {
    @State private var digitToPractise = 2
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
    
    @StateObject var arrayOfQuestions = dataToShare()
    @State private var tapCountForArray = 0
 
    var amountOfQuestionsToChoose = [5, 10, 20]
   
    
 

    var body: some View {

        NavigationView {
            ZStack {
                Color.yellow.ignoresSafeArea()
                
                LazyVStack (spacing: 20){
                    
                    Section {
                        Stepper("   \(digitToPractise)", value: $digitToPractise, in: 2...12, step: 1) {_ in
                            newGame()
                        }
                        .background(.purple)
                        .border(.black)
                    } header: {
                        Text("Сhoose digit to practise")
                            .font(.title2)
                    }
                    
                    Section {
                        Picker("amount of questions", selection: $selectedAmountQuestions) {
                            ForEach(amountOfQuestionsToChoose, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .padding(.horizontal)
                        .background(.purple)
                        .border(.black)
                        .pickerStyle(.segmented)
                    } header: {
                        Text("Choose amount of questions")
                            .font(.title2)
                    }
                    
                    Section {
                        HStack {
                            Text("\(digitToPractise) x \(randomElement)      =    ")
                                .frame(maxWidth: 200, maxHeight: 100)
                                .border(.black)
                                .background(.purple)
                            TextField("Your_answer", value: $userAnswer, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .border(.black)
                                .keyboardType(.decimalPad)
                                .focused($answerIsFocused)
                        }
                    } header: {
                        Text("Enter you answer")
                            
                    }
                    
                    
                    Section {
                        
                        VStack {
                            Text(userAnswer == 0 ? "Enter you answer" : "Your answer: \(isAnswerCorrect)")
                                .font(.title)
                                .foregroundColor(isAnswerCorrect == "Wright" ? .green : .red)
                                .foregroundColor(userAnswer == 0 ? .red : .primary)
                        }
                        
                     
                        
                        Text("Your score: \(score)")
                        
                        Spacer()
                        Button("NextQuestion") {
                            askQuestion()
                            
                        }
                        .frame(width: 115, height: 40)
                        .background(.purple)
                        .foregroundColor(.white)
                        .buttonBorderShape(.roundedRectangle(radius: 20))
                        
                        
                    } header: {
                        Text("Results")
                    }
                   
                    
                    Spacer()
                    
                    Section {
                        Button("Multiplication table") {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet) {
                            ZStack {
                                Color.green.ignoresSafeArea()
                                ShowSheetView(arrayOfQuestions: arrayOfQuestions)
                            }
                        }
                        
                    }
                    
                }
                .padding([.horizontal, .bottom])
                .navigationTitle("Multiplication Practise")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("New game") {
                            newGame()
                        }
                    }
                }
                .alert("StarNewGame", isPresented: $showAlert) {
                    Button("NewGame", action: newGame)
                } message: {
                    Text("You've finished \(selectedAmountQuestions)")
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            checkAnswer()
                            answerIsFocused = false
                            
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            generatedQuestions()
            print(arrayOfQuestions.items)
        })
        .onChange(of: digitToPractise) { newValue in
            arrayOfQuestions.items = []
            //            arrayOfQuestions = []
            generatedQuestions()
            print(arrayOfQuestions.items)
        }
    }
    
    func checkAnswer() {
        if userAnswer == digitToPractise * randomElement {
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
        userAnswer = 0
        showAlert = false
        randomElement = Int.random(in: 1...12)
    }
    
    func askQuestion() {
        randomElement = Int.random(in: 1...12)
        isAnswerCorrect = ""
        userAnswer = 0
    }
    
    func generatedQuestions() {
        for question in 1..<13 {
            let generatedQuestion = QuestionItems(textToShow: "\(question). \(digitToPractise) x \(question)", correctAnswer: "\(digitToPractise * question)")
            arrayOfQuestions.items.append(generatedQuestion)
            
            //        arrayOfQuestions.append(generatedQuestion)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
