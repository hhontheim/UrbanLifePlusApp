import SwiftUI
import PlaygroundSupport

struct MyView: View {
    @State var log: String = ""
    @State var value = ""
    
    var body: some View {
        VStack {
            Text("\(log)")
            TextField("ABC", text: $value, onEditingChanged: { stillTyping in
                if !stillTyping {
                    self.log.append("Done")
                }
            })
            TextField("ABC", text: $value)
            Button(action: {
                UIApplication.shared.endEditing()
            }) {
                Text("Hi")
            }
        }
    }
}

PlaygroundPage.current.setLiveView(MyView().previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (4th generation)")))

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
