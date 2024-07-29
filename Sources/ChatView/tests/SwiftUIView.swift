import SwiftUI


import SwiftUI

struct CounterView: View {
    @Binding var count: Int // 1. Use @Binding instead of @State

    init(count: Binding<Int>) {
        self._count = count
    }

    var body: some View {
        VStack {
            Text("Count: \(count)") // 3. Use the @Binding variable
                .font(.largeTitle)
            Button(action: {
                count += 1 // 4. Update the @Binding variable
            }) {
                Text("Increment")
            }
            .padding()
        }
    }
}

struct ContentView: View {
    @State private var count: Int = 0 // State is managed here
    
    var body: some View {
        VStack {
            CounterView(count: $count) // 5. Pass the state down using a binding
            Button(action: {
                count = 100 // This will now update the count in CounterView as well
            }) {
                Text("Button")
            }
            
        }
    }
}

#Preview {
    ContentView()
}
