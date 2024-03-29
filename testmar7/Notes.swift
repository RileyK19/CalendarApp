//
//  Notes.swift
//  testmar7
//
//  Created by Riley Koo on 3/19/24.
//

import SwiftUI

struct SingleNoteView : View {
    @State var note: Note
    var data: some View {
        TextEditor(text: $note.text)
    }
    var body: some View {
        NavigationLink {
            data
        } label: {
            noteDisplay
        }
    }
    var noteDisplay: some View {
        Text(note.ID)
            .foregroundStyle(Color.white)
            .font(.title2.bold())
        .background(
            RoundedRectangle(cornerRadius: 25)
                .shadow(color: Color.gray, radius: 2, x: 0, y: 2)
                .foregroundStyle(note.getColor())
                .opacity(0.8)
                .frame(width: 350, height: 100)
        )
        
    }
}

struct Note : Encodable, Decodable, Equatable {
    var ID: String
    var text: String
    var color: String
    func getColor() -> Color {
        return Color(hex: color)!
    }
}
