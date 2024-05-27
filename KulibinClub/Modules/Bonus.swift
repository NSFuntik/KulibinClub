//
//  Bonus.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import SwiftUI

struct Bonus: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
}

let exampleBonuses: [Bonus] = [
    Bonus(title: "40 баллов = 3 модуля", description: "После занятий (3 модуля) ребёнок клуба может получить максимально 40 баллов"),
    Bonus(title: "Посещаемость - 1 балл", description: "1 балл за 100% посещаемость в течение месяца. Максимум 30 баллов"),
    Bonus(title: "Соревнования и конкурсы", description: "Баллы за участие в соревнованиях и конкурсах. Узнать подробности"),
    Bonus(title: "Бонусы от педагога по итогам учебного года", description: "За дисциплинированность, активность, пунктуальность, за ответы на вопросы, за дополнительные задания"),
    Bonus(title: "Бонусы от родителей", description: "Отзывы, участие в опросах и акциях клуба, репосты и реклама клуба в соц. сетях")
]

struct BonusView: View {
    var bonus: Bonus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(bonus.title)
                .font(.headline)
            Text(bonus.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct BonusListView: View {
    let bonuses: [Bonus] = exampleBonuses
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Бонусная программа")
                    .font(.largeTitle)
                    .padding(.top)
                Text("Собери бонусы и обменяй их на фирменные подарки в конце текущего учебного года до 30 июня!")
                    .font(.body)
                    .padding(.bottom)
                Text("Ребёнку в личном кабинете выставляются баллы. В июне каждого года, на эти баллы можно будет приобрести призы: брендированные кружки, футболки, ручки, блокноты, канцтовары, игрушки и другие.")
                    .font(.body)
                    .padding(.bottom)
                ForEach(bonuses) { bonus in
                    BonusView(bonus: bonus)
                        .padding(.bottom, 10)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Бонусная программа")
    }
}
