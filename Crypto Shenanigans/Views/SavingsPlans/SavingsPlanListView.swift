import SwiftUI

struct SavingsPlanListView: View {
    
    @StateObject private var savingsPlanController = SavingsPlanController()
    
    // There seems to be a bug in the current SwiftUI version (https://stackoverflow.com/questions/63080830/swifui-onappear-gets-called-twice),
    // TODO: Remove this workaround once the bug is fixed by the framework.
    @State private var firstAppear = true
    
    @State private var confirmationDialogShow = false
    @State private var confirmationSavingsId = 0
    
    var body: some View {
        List {
            Section("Existing recurring payments") {
                ForEach(savingsPlanController.items) { savingsPlan in
                    SavingsPlanView(data: savingsPlan)
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive)  {
                                confirmationSavingsId = savingsPlan.id
                                confirmationDialogShow = true
                            } label : {
                                Label("Delete", systemImage: "trash.fill")
                            }
                    }
                }
            }
        }.confirmationDialog(
            "Are you sure you want to delete this savings plan ?",
            isPresented: $confirmationDialogShow,
            titleVisibility: .visible,
            presenting: confirmationSavingsId
        ) { savingsId in
            Button("Yes", role: .destructive) {
                Task.init {
                    await savingsPlanController.removeItem(savingsPlanId: savingsId)
                }
            }
            Button("No", role: .cancel) {}
        }
        .onAppear(perform: {
            if(firstAppear) {
                firstAppear = false
                Task.init {
                    await savingsPlanController.load()
                }
            }
        })
        .if(savingsPlanController.loading) { view in
            view.overlay(ProgressView())
        }.navigationTitle(Module.savingsPlan.title)
    }
}
