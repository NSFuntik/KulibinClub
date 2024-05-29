//
//  HeaderView.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import SwiftUI
#Preview {
    HeaderView(sideMenu: .constant(false))
}

struct HeaderView: View {
    @Binding var sideMenu: Bool

    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                sideMenu.toggle()
            }) {
                Image(systemName: "sidebar.squares.leading")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title3.italic())
                    .imageScale(.large).foregroundStyle(.ultraThickMaterial)
                    .background(Image(systemName: "rectangle.fill").symbolRenderingMode(.hierarchical).imageScale(.large).foregroundStyle(.accent.opacity(0.13)))
                    .symbolEffect(.disappear, isActive: sideMenu)
            }.padding(.leading, -13)
            Spacer()
          

        }.blur(radius: sideMenu ? 10 : 0)
            .padding(8)
            .frame(height: 55)
            .transaction { transaction in
                transaction.animation = .spring(.smooth)
                transaction.disablesAnimations = true
                transaction.isContinuous = true
            }
            .background(.clear)
    }
}
