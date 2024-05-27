//
//  Cources.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import SwiftUI

struct CourseListView: View {
    var courses: [Course] = exampleCourses
    let category: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(category)
                    .font(.largeTitle)
                    .padding(.top)
                ForEach(courses.filter { $0.category == category }) { course in
                    NavigationLink(destination: CourseDetailView(course: course)) {
                        CourseView(course: course)
                    }
                    .padding(.bottom, 10)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle(category)
    }

    struct CourseView: View {
        var course: Course

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(course.title ?? "Курс")
                    .font(.headline)
                Text(course.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                NavigationLink(destination: CourseDetailView(course: course)) {
                    Text("Подробнее")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
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
