//
//  Settings.swift
//  testmar7
//
//  Created by Riley Koo on 3/13/24.
//

import SwiftUI
import LocalAuthentication

struct OptionsView: View {
    @State var reset = false
    @State var unlocked = false
    @State var CV: ContentView
    @State var unlck: Bool = false
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            HStack {
                Spacer()
                    .frame(width: 15)
                Button {
                    withAnimation {
                        CV.settings.toggle()
                    }
                } label: {
                    Text("Close")
                        .font(.title3.bold())
                        .padding(5)
                        .frame(alignment: .leading)
                }
                Spacer()
            }
            HStack {
                Spacer()
                    .frame(width: 15)
                Button {
                    reset = true
                } label: {
                    Text("Reset Data")
                        .font(.title3.bold())
                        .padding(5)
                }
                .alert(
                    "Reset All Data?",
                    isPresented: $reset
                ) {
                    Button ("OK") {
                        if let bundleID = Bundle.main.bundleIdentifier {
                            UserDefaults.standard.removePersistentDomain(forName: bundleID)
                        }
                        CV.reminders = []
                        CV.activities = []
                        CV.RlistsNames = []
                        CV.colors = []
                        CV.remindLists = []
                        reset = false
                    }
                    Button ("cancel", role: .cancel) {
                        reset = false
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                    .frame(width: 15)
                if unlocked {
                    HStack {
                        Text("Need FaceID to unlock journals: ")
                            .font(.title3.bold())
                        Button {
                            CV.needAuth.toggle()
                            unlck.toggle()
                        } label : {
                            if unlck {
                                Image(systemName: "checkmark.square")
                                    .font(.title3.bold())
                            } else {
                                Image(systemName: "square")
                                    .font(.title3.bold())
                            }
                        }
                    }
                } else {
                    Button {
                        unlck = CV.needAuth
                        authenticate()
                    } label: {
                        Text("Require FaceID for Journals")
                            .font(.title3.bold())
                            .padding(5)
                        Text("Currently: ")
                            .font(.title3.bold())
                            .padding(5)
                        if CV.needAuth {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.title3.bold())
                                .padding(5)
                        } else {
                            Image(systemName: "xmark.shield.fill")
                                .font(.title3.bold())
                                .padding(5)
                        }
                    }
                }
                Spacer()
            }
        }
        Spacer()
    }
    func authenticate () {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Please authenticate to unlock journal"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    // authenticated successfully
                    unlocked = true
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
}
