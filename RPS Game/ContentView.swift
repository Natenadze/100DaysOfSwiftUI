//
//  ContentView.swift
//  RPS Game
//
//  Created by Davit Natenadze on 02.06.23.
//

import SwiftUI


struct ContentView: View {
    
    @State var showAlert = false
    @State var showComputerImage = false
    @State var playerScore = 0
    @State var computerScore = 0
    @State var questionCount = 0

    
    @State var computerChoice = Int.random(in: 1...3)
    
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.cyan, .purple]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                Text("Round: \(questionCount)/8")
                    .padding(.top, 20)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Let's play Game")
                    .padding(.top, 20)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.white)
                
             
                
                Spacer()
                
                // MARK: - Computer Image
                Image(showComputerImage ? String(computerChoice) : "questionMark")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .rotation3DEffect(
                        .degrees(showComputerImage ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(.easeInOut(duration: 0.5), value: showComputerImage)
                
                
                
                Spacer()
                
                // MARK: - Buttons
                HStack(spacing: 0) {
                    customButton(currentImage: 1) {
                        showComputerImage.toggle()
                        takeAction(1)
                    }
                    .disabled(showComputerImage)  // disable until animation is not finished :)
                    
                    customButton(currentImage: 2) {
                        showComputerImage.toggle()
                        takeAction(2)
                    }
                    .disabled(showComputerImage)
                    
                    customButton(currentImage: 3) {
                        showComputerImage.toggle()
                        takeAction(3)
                    }
                    .disabled(showComputerImage)
                }

                
                Spacer()
                
                // MARK: - Results
                
                HStack {
                    Spacer()
                    
                    Text("You:")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                    Text("\(playerScore)")
                        .font(.system(size: 23))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Computer:")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                    Text("\(computerScore)")
                        .font(.system(size: 23))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                Spacer()
                
            }
            
        }
        .alert("Game Over", isPresented: $showAlert) {
            Button("Continue", action: nextRound)
        } message: {
           Text(showAlertMessage())
                .font(.system(size: 40))
        }
        
        
    }
    

}

// MARK: -

extension ContentView {
    
    func takeAction(_ playerChoice: Int) {
        questionCount += 1
        
        checkAnswer(with: playerChoice)
        
        if questionCount == 8 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showAlert = true
                playerScore = 0
                computerScore = 0
                questionCount = 0
            }
            
            return
        }
        
        nextRound()
    }
    
    func checkAnswer(with choice : Int) {
        
        switch choice {
        case 1:
            if computerChoice == 2 {
                computerScore += 1
            } else if computerChoice == 3 {
                playerScore += 1
            }
        case 2:
            if computerChoice == 3 {
                computerScore += 1
            } else if computerChoice == 1 {
                playerScore += 1
            }
        default:
            if computerChoice == 1 {
                computerScore += 1
            } else if computerChoice == 2 {
                playerScore += 1
            }
        }
    }
    
    
    
    func nextRound() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            showComputerImage.toggle()
            computerChoice = Int.random(in: 1...3)
        }
    }
    
    func showAlertMessage() -> String {
        if playerScore > computerScore {
            return "Well done on your procrastination"
        } else if playerScore < computerScore {
            return "Is that all you've got?"
        }else {
            return "It's a DRAW, Lets Play one more"
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



// MARK: - Helpers


struct customButton: View {
    var currentImage: Int
    var completion: () -> Void
    
    var body: some View {
        Button {
            completion()
        } label: {
            MakeButtonWithImage(name: "\(currentImage)")
        }
    }
}

struct MakeButtonWithImage: View {
    let name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
    }
}
