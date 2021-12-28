import SwiftUI

struct SavingsPlanListView: View {
    
    @StateObject private var savingsPlanController = SavingsPlanController()
    
    // There seems to be a bug in the current SwiftUI version (https://stackoverflow.com/questions/63080830/swifui-onappear-gets-called-twice),
    // TODO: Remove this workaround once the bug is fixed by the framework.
    @State private var firstAppear = true
    
    @State private var confirmationDialogShow = false
    @State private var confirmationSavingsId = 0
    
    @State private var createModeActive = false
    @State private var editModeActive = false
    
    @EnvironmentObject var platformModelController: PlatformModelController
    
    func reload () async {
        await savingsPlanController.load()
    }
    
    var body: some View {
        NavigationLink(destination: CreateOrEditSavingsPlan(editMode: false, reloadSavingsPlans: self.reload).environmentObject(platformModelController), isActive: $createModeActive) {
            EmptyView()
        }.hidden()
        List {
            Section("Existing recurring payments") {
                ForEach(savingsPlanController.items) { savingsPlan in
                    HStack {
                        NavigationLink(destination: CreateOrEditSavingsPlan(editMode: true,reloadSavingsPlans: self.reload,
                                                                            platformId: savingsPlan.platformName, tradingPair: savingsPlan.tradingPair, amount: savingsPlan.amount,frequencyUnit: FrequencyUnit(rawValue:savingsPlan.frequencyUnit) ?? .day,
                                                                            frequencyValue: savingsPlan.frequencyValue, currency: savingsPlan.currency,
                                                                            savingsPlanId: savingsPlan.id)
                                        .environmentObject(platformModelController)) {
                            SavingsPlanView(data: savingsPlan)
                        }
                    }.swipeActions(allowsFullSwipe: false) {
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
                    await reload()
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
        }
        .navigationTitle(Module.savingsPlan.title)
        .navigationBarItems(trailing: Button(action: {
            createModeActive = true
        }) {
            Label("Create", systemImage: "plus")
        })

    }
}
