//
//  TrialLessonForm.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 27.05.2024.
//

import SwiftPro
import SwiftUI

#Preview {
    Color.accentColor
        .popup(alignment: .top, isPresented: .constant(true)) { _ in
            TrialLessonForm().padding(8).shadow(.elevated)
        }
}

struct TrialLessonForm: View {
    @State private var form = TrialLesson()

    let directions = ["Робототехника", "Программирование", "Компьютерная графика и 3D", "Курсы для взрослых"]
    let cities = ["Москва", "Санкт-Петербург", "Новосибирск", "Екатеринбург"]

    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
                   Section(header: Text("")) {
                       FloatingTextField(
                           placeholderText: "Имя ребенка",
                           colorPalette: (primary: .accent, secondary: .about)
                       ) { _, new in form.childName = new }
                           .foregroundStyle(.accent, .accent.secondary)
                           .background(.thickMaterial, in: Capsule())

                       FloatingTextField(
                           placeholderText: "Имя родителя",
                           colorPalette: (primary: .accent, secondary: .about)
                       ) { _, new in form.parentName = new }
                           .foregroundStyle(.accent, .accent.secondary)
                           .background(.thickMaterial, in: Capsule())

                       FloatingTextField(
                           placeholderText: "Телефон",
                           colorPalette: (primary: .accent, secondary: .about)
                       ) { _, new in form.phoneNumber = new }
                           .foregroundStyle(.accent, .accent.secondary)
                           .background(.thickMaterial, in: Capsule())
                           .keyboardType(.phonePad)
                       FloatingTextField(
                           placeholderText: "Электронная почта",
                           colorPalette: (primary: .accent, secondary: .about)
                       ) { _, new in form.email = new }
                           .foregroundStyle(.accent, .accent.secondary)
                           .background(.thickMaterial, in: Capsule())
                           .keyboardType(.emailAddress)

                   }.padding(.top, 16) // .textFieldStyle(RoundedBorderTextFieldStyle())
                   LabeledContent {
                       Picker("Выберите направление", selection: $form.direction) {
                           ForEach(directions, id: \.self) { direction in
                               Text(direction).tag(direction)
                           }
                       }.pickerStyle(.automatic)
                   } label: {
                       Text("Выберите направление:").font(.title3.weight(.medium)).foregroundStyle(.primary).multilineTextAlignment(.leading)
                   }.padding(10)

                   LabeledContent { Picker("Выберите город", selection: $form.city) {
                       ForEach(cities, id: \.self) { city in
                           Text(city).tag(city)
                       }
                   }.pickerStyle(.automatic) } label: {
                       Text("Выберите направление:").font(.title3.weight(.medium)).foregroundStyle(.primary).multilineTextAlignment(.leading)
                   }.padding(10)

                   Toggle("Я согласен на обработку моих персональных данных в соответствии с условиями и договором-оферты", isOn: $form.isAgreed).font(.callout).padding(20)

                   Button(action: { print("Form submitted: \(form)") /* Handle form submission */ }) {
                       Text("Попробовать бесплатно").font(.title3.bold()).padding()
                   }
                   .vibrantForeground(thick: true).background(form.isAgreed ? .accent : .secondary.opacity(0.33), in: Capsule()).shadow(form.isAgreed ? .elevated : .none)
                   .disabled(!form.isAgreed)
               })
               .padding(16).background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14)).clipped().shadow(radius: 3)
               .overlay(alignment: .top) {
                   HStack {
                       Spacer()
                       Text("Запишитесь на пробный урок")
                           .font(.title).foregroundStyle(.primary).bold().multilineTextAlignment(.center)
                       Spacer()
                   }
                   .padding(4, 12)
                   .background(.thinMaterial, in: .capsule(style: .continuous))
                   .clipped() // .shadow(.sticker)
                   .padding(.horizontal, 14).padding(.top, -33)
               }
    }

    struct TrialLesson {
        var childName: String = ""
        var parentName: String = ""
        var phoneNumber: String = ""
        var email: String = ""
        var direction: String = ""
        var city: String = ""
        var isAgreed: Bool = false
    }
}
