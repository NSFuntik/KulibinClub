//
//  FAQ.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import SwiftUI

let exampleFAQs: [FAQ] = [
    FAQ(question: "Что такое робототехника для детей?", answer: "Если ребёнок интересуется наукой и технологиями, то робототехника может стать отличным выбором. Она помогает развить его интересы и навыки, а также даст возможность применить свои знания на практике."),
    FAQ(question: "Стоит ли отдавать ребенка на робототехнику?", answer: "Если ребёнок интересуется наукой и технологиями, то робототехника может стать отличным выбором. Она помогает развить его интересы и навыки, а также даст возможность применить свои знания на практике."),
    FAQ(question: "Какие навыки развивает робототехника для детей?", answer: "Если ребёнок интересуется наукой и технологиями, то робототехника может стать отличным выбором. Она помогает развить его интересы и навыки, а также даст возможность применить свои знания на практике."),
    FAQ(question: "Как помочь ребенку заинтересоваться робототехникой?", answer: "Если ребёнок интересуется наукой и технологиями, то робототехника может стать отличным выбором. Она помогает развить его интересы и навыки, а также даст возможность применить свои знания на практике."),
]

struct FAQView: View {
    var faq: FAQ

    var body: some View {
        DisclosureGroup {
            Text(faq.answer)
                .font(.subheadline)
                .foregroundColor(.secondary)
        } label: {
            Text(faq.question)
                .font(.headline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct FAQListView: View {
    @ObservedObject var viewModel = FAQViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Вопросы и ответы")
                    .font(.largeTitle)
                    .padding(.top)
                Text("Ответим на любые вопросы и поможем с выбором")
                    .font(.body)
                    .padding(.bottom)
                ForEach(viewModel.faqs) { faq in
                    FAQView(faq: faq)
                        .padding(.bottom, 10)
                }
                Spacer()
                Button(action: {
                    // Действие для "Задать вопрос"
                }) {
                    Text("Задать вопрос")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Вопросы и ответы")
        .onAppear {
            self.viewModel.fetchFAQs()
        }
    }
}
