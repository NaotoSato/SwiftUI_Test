//
//  QuizView.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/03/31.
//

import SwiftUI

struct QuizItem {
    let question: String
    var choices: [String]
    let correctAnswer: String
}

struct QuizView: View {
    @State var isShowingScoreView = false
    @State var isShowingResultSymbol = false
    @State var isAnswerCorrect = false
    @State var currentQuestionIndex = 0
    @State var correctCount = 0
    
    let choices = ["ライオン", "ウサイン・ボルト", "チーター", "馬"]
    
    let quizItems = [
        QuizItem(
            question: "次のうち、世界で最も速く走る動物はどれですか？",
            choices: ["チーター", "ライオン", "ウサイン・ボルト", "馬"],
            correctAnswer: "チーター"
        ),
        QuizItem(
            question: "次のうち、飛ぶことができない鳥はどれですか？",
            choices: ["ペンギン", "フクロウ", "ハト", "スズメ"],
            correctAnswer: "ペンギン"
        ),
        QuizItem(
            question: "次のうち、哺乳類でない動物はどれですか？",
            choices: ["イルカ", "カメ", "コウモリ", "ヒト"],
            correctAnswer: "カメ"
        ),
        QuizItem(
            question: "次のうち、夜行性でない動物はどれですか？",
            choices: ["ライオン", "コアラ", "ゾウ", "フクロウ"],
            correctAnswer: "ゾウ"
        ),
        QuizItem(
            question: "次のうち、最も長い首を持つ動物はどれですか？",
            choices: ["キリン", "アルパカ", "象", "馬"],
            correctAnswer: "キリン"
        )
    ]
    
    var body: some View {
        ZStack {
            VStack {
                Text("問題番号: \(currentQuestionIndex+1)/\(quizItems.count)")
                    .font(.headline)
                    .padding(10)
                    .background(.originalGreen)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text(quizItems[currentQuestionIndex].question)
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.originalLightGreen)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.originalGreen, lineWidth: 5)
                    )
                    .frame(maxHeight: .infinity)
                
                ForEach(quizItems[currentQuestionIndex].choices, id: \.self) { choice in
                    Button {
                        print("\(choice)を選択しました。")
                        print("正解は\(quizItems[currentQuestionIndex].correctAnswer)でした。")
                        
                        if choice == quizItems[currentQuestionIndex].correctAnswer {
                            print("正解です。")
                            correctCount += 1
                            isAnswerCorrect = true
                        } else {
                            print("不正解です。")
                            isAnswerCorrect = false
                        }
                        
                        isShowingResultSymbol = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isShowingResultSymbol = false
                            if currentQuestionIndex + 1 >= quizItems.count {
                                isShowingScoreView = true
                                return
                            }
                            currentQuestionIndex += 1
                        }
                    } label: {
                        Text(choice)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .font(.title.bold())
                            .background(Color.originalSkin)
                            .foregroundStyle(.originalBrown)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .fullScreenCover(isPresented: $isShowingScoreView) {
                        ScoreView(scoreText: "\(quizItems.count)問中\(correctCount)問正解！")
                    }
                }
            }
            .padding()
            
            if isShowingResultSymbol {
                Text(isAnswerCorrect ? "○" : "✗")
                    .font(.system(size: 1000))
                    .minimumScaleFactor(0.1)
                    .foregroundStyle(isAnswerCorrect ? .green : .red)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.5))
            }
        }
        .backgroundImage()
    }
}

#Preview {
    QuizView()
}
