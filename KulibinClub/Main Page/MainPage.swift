//
//  MainPage.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import FirebaseAuth
import SwiftUI
#Preview {
    NavigationStack {
        VStack {
            MainView()
        }
    }
}

struct MainView: View {
    @Environment(\.screen) var screen: UIScreen
    var body: some View {
        ScrollView {
            PageTopIllustration
            VStack(spacing: 20) {
                TrialLessonForm()
                AboutBlock()
//                DirectionsBlock()
//                EventsBlock()
//                NewsBlock()
//                PedagogicStaffBlock()
                FAQBlock()
                Footer()
            }
            .padding(.horizontal, 8)
        }
        .withScreen().frame(width: screen.bounds.width)
        .ignoresSafeArea(.container, edges: .bottom)
    }

    var PageTopIllustration: some View {
        Image(.mainPageIllustration)
            .resizable()
            .scaledToFill().frame(width: screen.bounds.width, height: 400)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .containerShape(RoundedRectangle(cornerRadius: 12))
            .clipped()

            .overlay(alignment: .bottom) {
                VStack(alignment: .center, spacing: 33) {
                    
                    Text("Развивающие занятия для детей и подростков")
                        .font(.largeTitle).bold().fontDesign(.rounded).multilineTextAlignment(.trailing)
                        .padding(33).padding(.top, 40).lineLimit(2).minimumScaleFactor(0.77)
                        .vibrantForeground(thick: true)
                    Image(.kulibinCharacter)
                        .resizable().scaledToFill().frame(box: 180)
                }.shadow(.sticker)
            }
    }

    struct AboutBlock: View {
        var body: some View {
            VStack(spacing: -16) {
                // Заголовок с изображением робота и текстом
                VStack(alignment: .center) {
                    Image(.about).resizable().aspectRatio(contentMode: .fill).frame(width: .screenWidth)
                        .background(alignment: .bottom) {
                            LinearGradient(colors: [Color.clear, Color(.about)], startPoint: .top, endPoint: .bottom)
                        }
                        .overlay(alignment: .bottom) {
                            Text("Kulibin club - это").font(.largeTitle).fontWeight(.bold).padding(.bottom, 16).shadow(.sticker)
                        }.clipped()
                }
                .contentShape(Rectangle()).clipped()

                ScrollView(.horizontal) {
                    // Карточки
                    HStack(spacing: 20) {
                        FeatureCard(
                            imageName: "https://kulibin.bokus.ru/upload/resize_cache/iblock/2d7/400_400_1/x30f4zjdbezk3zc2il0iss4f8c0sesh9.jpeg",
                            title: "Развитие логики",
                            description: "Развитие полезных навыков и мышления с помощью робототехники и программирования"
                        )
                        FeatureCard(
                            imageName: "https://kulibin.bokus.ru/upload/resize_cache/iblock/664/400_400_1/nm5jupyga3yvyrmpn831s4d3pa3blmzu.jpeg",
                            title: "Коллектив",
                            description: "Ребёнок обучается в коллективе сверстников квалифицированными специалистами - педагогами"
                        )
                        FeatureCard(
                            imageName: "https://kulibin.bokus.ru/upload/resize_cache/iblock/91c/400_400_1/d0sxfzrkhew1bgthak3n6m6qx9ebexg9.jpg",
                            title: "Победители",
                            description: "Престижных международных и национальных чемпионатов и олимпиад по робототехнике"
                        )
                    }.padding(.horizontal, 16)
                }
            }.frame(width: .screenWidth)
        }

        struct FeatureCard: View {
            let feature: Feature

            var body: some View {
                VStack {
                    AsyncImage(url: URL(string: feature.imageName) ?? .currentDirectory()) {
                        $0
                            .resizable().aspectRatio(contentMode: .fill).frame(box: 150).clipped()
                    } placeholder: { ProgressView().progressViewStyle(.circular) }
                        .frame(box: 144)
                        .clipShape(RoundedRectangle(cornerRadius: 14), style: FillStyle())
                        .padding(8)
                    VStack(alignment: .center, spacing: 10) {
                        Text(feature.title).font(.headline).foregroundStyle(.orange)
                        Text(feature.description).font(.subheadline).multilineTextAlignment(.leading)
                    }.padding(.horizontal, 4).padding(.bottom, 6)

                    Spacer()
                }
                .frame(width: 160, height: 333).background(.ultraThickMaterial).cornerRadius(14).shadow(.elevated)
            }

            init(
                imageName: String, title: String, description: String
            ) {
                self.feature = Feature(
                    imageName: imageName,
                    title: title,
                    description: description
                )
            }
        }

        struct Feature: Identifiable, Hashable {
            let id: UUID = UUID()
            let imageName: String
            let title: String
            let description: String
        }
    }

    struct DirectionsBlock: View {
        var body: some View {
            CourseSelectionFlow()
        }
    }

    struct EventsBlock: View {
        @State private var events: [Event] = []

        var body: some View {
            List(events) { event in
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.headline)
                    Text(event.description)
                        .font(.subheadline)
                }
            }
            .onAppear {
                EventService.shared.fetchEvents { events in
                    self.events = events
                }
            }
        }
    }

    struct NewsBlock: View {
        @State private var news: [News] = exampleNews

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(news.indices, id: \.self) { index in
                    NewsCardView(
                        newsTitle: news[index].title ?? "Новость \(index + 1)",
                        newsDescription: news[index].description ?? "Описание новости \(index + 1)"
                    )
                }
            }
            .onAppear {
                NewsService.shared.fetchNews { news in
                    self.news = news
                }
            }
        }
    }

    struct NewsCardView: View {
        let newsTitle: String
        let newsDescription: String

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(newsTitle)
                    .font(.headline)
                Text(newsDescription)
                    .font(.subheadline)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
    }

    struct PedagogicStaffBlock: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Преподаватели")
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(0 ..< 5) { index in
                            TeacherCardView(teacherName: "Преподаватель \(index + 1)")
                        }
                    }
                }
            }
        }
    }

    struct TeacherCardView: View {
        let teacherName: String

        var body: some View {
            VStack {
                Text(teacherName)
                    .font(.headline)
                    .padding()
                // Добавьте изображение преподавателя и краткое описание
            }
            .frame(width: 200)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
    }

    struct FAQBlock: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Часто задаваемые вопросы")
                    .font(.headline)
                ForEach(0 ..< 5) { index in
                    FAQCardView(question: "Вопрос \(index + 1)", answer: "Ответ на вопрос \(index + 1)")
                }
            }
        }

        struct FAQCardView: View {
            let question: String
            let answer: String

            var body: some View {
                VStack(alignment: .leading, spacing: 10) {
                    Text(question)
                        .font(.headline)
                    Text(answer)
                        .font(.subheadline)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
            }
        }
    }

    struct Footer: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Divider().background(.accent).shadow(color: .accent, radius: 2, y: -1)
                Text("Контакты")
                    .font(.headline)
                Text("**Адрес**: г. Москва, ул. Пушкина, д. 10")
                Text("**Телефон**: +7 (123) 456-78-90")
                Text("**Email**: info@kulibin.club")
                // TODO: Добавить карту или другую информацию по необходимости
            }
            .spacing()
            .font(.footnote)
            .padding(18)
        }
    }
}
