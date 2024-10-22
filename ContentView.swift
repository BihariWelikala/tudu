import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool
}

struct ContentView: View {
    @State private var tasks: [Task] = [Task(name: "Sample Task", isCompleted: false)]
    @State private var newTaskName: String = ""
    @State private var showTaskInputPopup = false // Control the popup visibility

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                // App Title
                HStack {
                    Text("Tudu")
                }
                .font(.system(.largeTitle, design: .rounded))
                .foregroundColor(Color(hex: "#4B0082"))
                .padding(.horizontal)
                .bold()

                // List of Tasks with Custom Checkboxes
                List {
                    ForEach(tasks) { task in
                        HStack {
                            // Custom checkbox using an image
                            Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                .resizable()
                                .foregroundColor(Color(hex: "#4B0082"))
                                .frame(width: 20, height: 20)
                                .onTapGesture {
                                    toggleTaskCompletion(task)
                                }
                            
                            Text(task.name)
                                .strikethrough(task.isCompleted, color: Color(hex: "#4B0082")) // Strikethrough if task is completed
                                .foregroundColor(task.isCompleted ? .gray : .black) // Dim text color if completed
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.inset)

                // "Add Task" Button - Opens Popup
                Button {
                    showTaskInputPopup.toggle() // Show the popup
                } label: {
                    HStack(spacing: 7) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Task")
                    }
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(Color(hex: "#4B0082")) // Set button text color
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)

            // Popup
            if showTaskInputPopup {
                Color.black.opacity(0.3) // Background dimming effect
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showTaskInputPopup = false // Dismiss popup when tapping outside
                    }
                
                TaskInputPopup(newTaskName: $newTaskName, addTask: addTask, showPopup: $showTaskInputPopup)
                    .frame(maxWidth: 400) // Set a maximum width for the popup
                    .background(Color.white) // Popup background color
                    .cornerRadius(12)
                    .shadow(radius: 10) // Add a shadow effect
                    .padding()
                    .transition(.scale) // Add a transition effect
            }
        }
    }

    // Function to toggle the task completion status
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    // Function to add a new task
    func addTask() {
        if !newTaskName.isEmpty {
            tasks.append(Task(name: newTaskName, isCompleted: false))
            newTaskName = "" // Clear the input field
        }
    }

    // Function to delete tasks
    func delete(_ indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
    }
}

// Popup view for entering a new task
struct TaskInputPopup: View {
    @Binding var newTaskName: String
    var addTask: () -> Void
    @Binding var showPopup: Bool // Binding to control the popup visibility

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Add Task")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#4B0082")) // Use the custom color for the title
            }
            TextField("Task", text: $newTaskName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add") {
                addTask()
                showPopup = false // Close the popup after adding
            }
            .disabled(newTaskName.isEmpty) // Disable button if input is empty
            .padding(.vertical, 4)
            .padding(.horizontal, 20)
            .background(newTaskName.isEmpty ? Color.gray : Color(hex: "#4B0082"))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

// Preview
#Preview {
    ContentView()
}
