//
//  Cources.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import SwiftUI
extension Array {
    func groupBy<T: Hashable>(key: (Element) -> T) -> [T: [Element]] {
        var dict = [T: [Element]]()
        for item in self {
            let key = key(item)
            if case nil = dict[key]?.append(item) {
                dict[key] = [item]
            }
        }
        return dict
    }
}

#Preview(body: {
    NavigationStack {
        CourseListView(category: "Робототехника")
            .toolbar(content: { ToolbarItem(placement: .navigation) {
                HeaderView(sideMenu: .constant(false))
            } })
    }
})
struct TrialButton: View {
    @Binding var popover: Bool
    var body: some View {
        Button(action: {
            popover.toggle()
        }, label: {
            Label("Записаться", systemImage: "pencil.and.outline")
                .symbolRenderingMode(.hierarchical)
                .vibrantForeground(thick: true).labelStyle(.titleAndIcon)
                .font(.title2.weight(.semibold).monospaced())
                .padding(8, 24)
                .materialBackground(with: .systemUltraThinMaterial, blur: 1, clipped: Capsule(), filled: .accentColor.opacity(0.44), bordered: .accent, width: 0.5)

        }).frame(width: .screenWidth, alignment: .center)
            .environment(\.fsBoolBinding, $popover)
    }
}

struct CourseListView: View {
    @State var popover: Bool = false
    var courses: [Course] = exampleCourses
    let category: String
    var groupedCourses: [String: [Course]] {
        courses.groupBy { $0.category }
    }

    var body: some View {
        List {
            ForEach(Array(courses.groupBy(key: { $0.category }).keys), id: \.self) { (courseKey: String) in
                if let courcesForCategory = groupedCourses[courseKey] {
                    Section(header: Text(courcesForCategory.first?.category ?? "Unknown Header")) {
                        ForEach(courcesForCategory) { course in
                            NavigationLink(destination: CourseDetailView(course: course)) {
                                CourseView(course: course)
                            }
                        }
                    }
                }
            }
        }

        .listStyle(.insetGrouped).ignoresSafeArea(.container, edges: .bottom)
        .toolbarTitleDisplayMode(.large)
        .navigationTitle("Курсы")
        .toolbar(content: { TrialButton(popover: $popover).labelStyle(.titleOnly) })
//        .popup(alignment: .bottom, isPresented: $popover, content: { p in
//            if p { ZStack(alignment: .center) {
//                TrialLessonForm().shadow(.elevated)
//            } }
//        }).animation(.bouncy, value: popover)
    }

    struct CourseView: View {
        var course: Course

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(course.ageGroup).font(.caption).foregroundStyle(.secondary).padding(2, 5).background(Capsule().stroke(lineWidth: 1).fill(.secondary))
                Text(course.title)
                    .font(.headline)
                Text(course.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }

    struct CourseDetailView: View {
        var course: Course

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(course.title)
                        .font(.largeTitle)

                    Text(course.description)
                        .font(.body)

                    HStack {
                        Text("Дополнительные данные:")
                        Spacer()
                        Text("Возраст: \(course.ageGroup)")
                    }

                    Button(action: {
                        // Действие при нажатии на кнопку
                    }) {
                        Text("Записаться")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Преимущества курса:")
                            .font(.headline)
                        ForEach(course.benefits, id: \.self) { benefit in
                            Text("• \(benefit)")
                        }
                    }

                    Text("Программа курса")
                        .font(.headline)
                    Text(course.details)
                        .font(.body)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Дальнейшие рекомендации")
                            .font(.headline)
                        ForEach(exampleCourses.filter { $0.category == course.category && $0.id != course.id }) { recommendedCourse in
                            NavigationLink(destination: CourseDetailView(course: recommendedCourse)) {
                                Text(recommendedCourse.title)
                                    .foregroundColor(.blue)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Мероприятия")
                            .font(.headline)
                        // Добавьте мероприятия здесь
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Запишитесь на урок")
                            .font(.headline)
                        TextField("Имя", text: .constant(""))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        TextField("Телефон", text: .constant(""))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        TextField("Возраст", text: .constant(""))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        Button(action: {
                            // Действие при нажатии на кнопку
                        }) {
                            Text("Записаться")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(course.title)
        }
    }
}

struct CourseSelectionFlow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Выбор направления")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0 ..< 10) { index in
                        CourseCardView(courseName: "Курс \(index + 1)")
                    }
                }
            }
        }
    }
}

struct CourseCardView: View {
    let courseName: String

    var body: some View {
        VStack {
            Text(courseName)
                .font(.headline)
                .padding()
            // Добавьте изображение и описание курса
        }
        .frame(width: 200)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
