//
//  ContentView.swift
//  trollfs
//
//  Created by WhitetailAni on 11/30/23.
//

import SwiftUI

struct ContentView: View {
    @State var std = ""
    @State var lol = false
    
    @State var trolled = false
    
    var body: some View {
        VStack {
            Text(" ")
            Text("this app was coded in 15 minutes")
                .multilineTextAlignment(.center)
            Text("during my calc BC class")
                .multilineTextAlignment(.center)
            Text(" ")
            
            Button(action: {
                do {
                    try FileManager.default.createDirectory(at: URL(fileURLWithPath: "/var/mobile/trollfs"), withIntermediateDirectories: false)
                } catch {
                    print(error.localizedDescription)
                }
                if #available(iOS 16.0, *) {
                    std = trollfs.spawn(command: "/sbin/mount", args: ["-o", "rw", "-t", "apfs", "/dev/disk1s1", "/var/mobile/trollfs"], root: true)
                } else {
                    std = trollfs.spawn(command: "/sbin/mount", args: ["-o", "rw", "-t", "apfs", "/dev/disk0s1s1", "/var/mobile/trollfs"], root: true)
                }
                if std == """


""" {
                    trolled = FileManager.default.fileExists(atPath: "/var/mobile/trollfs/.file")
                    std = "it probably mounted, go check /var/mobile/trollfs in your file manager of choice"
                }
            }) {
                Text("troll my filesystem")
            }
            Text(" ")
            Button(action: {
                std = trollfs.spawn(command: "/sbin/umount", args: ["/var/mobile/trollfs"], root: true)
                if std == """


""" {
                    trolled = FileManager.default.fileExists(atPath: "/var/mobile/trollfs/.file")
                    std = "it probably unmounted, go check /var/mobile/trollfs in your file manager of choice"
                }
            }) {
                Text("untroll my filesystem")
            }
            
            UIKitTextView(text: $std, fontSize: 25.0, isTapped: $lol)
            
            HStack {
                Text("is your fs trolled?")
                Image(systemName: trolled ? "checkmark.square" : "square")
            }
            .onAppear {
                trolled = FileManager.default.fileExists(atPath: "/var/mobile/trollfs/.file")
            }
            Text(" ")
            
            Text("credits to amy for CommandRunner.swift")
        }
    }
}

struct UIKitTextView: UIViewRepresentable {
    @Binding var text: String
    @State var fontSize: CGFloat
    @Binding var isTapped: Bool

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        let opacity = 0.25
        textView.delegate = context.coordinator
        textView.isUserInteractionEnabled = !text.isEmpty
        textView.isSelectable = true
        
        if #available(tvOS 15.0, *) {
            if let dynamicColor = UIColor(named: "systemBackground") {
                textView.backgroundColor = dynamicColor.withAlphaComponent(opacity)
            } else {
                textView.backgroundColor = UIColor.darkGray.withAlphaComponent(opacity)
            }
        } else {
            textView.backgroundColor = UIColor.darkGray.withAlphaComponent(opacity)
        }
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.textViewTapped))
        textView.addGestureRecognizer(tapGesture)
        
        if isTapped {
            textView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        } else {
            textView.panGestureRecognizer.allowedTouchTypes = [0]
        }
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.isUserInteractionEnabled = !text.isEmpty
        if isTapped {
            uiView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        } else {
            uiView.panGestureRecognizer.allowedTouchTypes = [0]
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, isTapped: $isTapped)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: UIKitTextView
        @Binding var isTapped: Bool
    
        init(_ parent: UIKitTextView, isTapped: Binding<Bool>) {
            self.parent = parent
            _isTapped = isTapped
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        @objc func textViewTapped() {
            parent.isTapped.toggle()
        }
    }
}
