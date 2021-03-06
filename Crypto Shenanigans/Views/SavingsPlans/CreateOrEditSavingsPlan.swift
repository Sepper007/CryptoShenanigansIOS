import SwiftUI

struct FrequencyValue {
    var number: Int
    var text: String
}

struct CreateOrEditSavingsPlan: View {
    
    var editMode: Bool
    
    var reloadSavingsPlans: (() async -> Void);
    
    @Environment(\.presentationMode) var presentation
    
    @State private var platformId: String
    @State private var tradingPair: String
    @State private var amount: Double
    @State private var frequencyUnit: FrequencyUnit
    @State private var frequencyValue: Int
    @State private var currency: String
    
    private var savingsPlanId: Int
    
    init(editMode: Bool, reloadSavingsPlans: @escaping (() async -> Void), platformId: String = "", tradingPair: String = "", amount: Double = 0.0, frequencyUnit: FrequencyUnit = .day, frequencyValue: Int = 1, currency: String = "", savingsPlanId: Int = 0) {
        self.editMode = editMode
        
        self._platformId = State(initialValue: platformId)
        self._tradingPair = State(initialValue: tradingPair)
        self._amount = State(initialValue: amount)
        self._frequencyUnit = State(initialValue: frequencyUnit)
        self._frequencyValue = State(initialValue: frequencyValue)
        self._currency = State(initialValue: currency)
        self.savingsPlanId = savingsPlanId
        self.reloadSavingsPlans = reloadSavingsPlans
    }
    
    var availableCurrencies: [String] {
        if(tradingPair == "") {
            return []
        }
        
        return tradingPair.components(separatedBy: "/")
    }
    
    func generateFrequencyValue (num: Int, desc: String) -> FrequencyValue {
        return FrequencyValue(number: num, text: "every \(num > 1 ? "\(num) " : "")\(desc)\(num > 1 ? "s" : "")")
    }
    
    private var availableFrequencies: [FrequencyValue] {
        switch frequencyUnit {
        case .hour:
            return [1,2,4,6,12].map({generateFrequencyValue(num: $0, desc: FrequencyUnit.hour.rawValue)})
        case .day:
            return (1...30).map({generateFrequencyValue(num: $0, desc: FrequencyUnit.day.rawValue)})
        case .minute:
            return [generateFrequencyValue(num: 30, desc: FrequencyUnit.minute.rawValue)]
        }
    }
    
    @EnvironmentObject private var platformModelController: PlatformModelController
    
    @State private var toggleIsOn = false
    
    @StateObject private var platformMetaController = PlatformMetaController()
    
    @StateObject private var savingsPlanController = SavingsPlanController()
    
    var body: some View {
        Form {
            Section("General") {
                Picker("Platform:" , selection: $platformId) {
                    ForEach(platformModelController.data) { platform in
                        Text(platform.description).tag(platform.id)
                    }
                }.onChange(of: platformId) { id in
                    Task.init{
                        // After the platform was changed, reset all the other states to prevent an invalid
                        // config being sent to the backend
                        tradingPair = ""
                        amount = 0.0
                        await platformMetaController.load(platformId: platformId)
                    }
                }.padding().disabled(editMode)
                Picker("Trading Pair:" , selection: $tradingPair) {
                    ForEach(platformMetaController.data?.supportedCoins ?? []) { coin in
                        Text(coin.marketId).tag(coin.marketId)
                    }
                }.onChange(of: tradingPair) {
                    currency = $0.components(separatedBy: "/")[0]
                }.if(platformMetaController.loading) { view in
                    view.overlay(ProgressView())
                }.padding().disabled(editMode)
            }
            Section("Coin") {
                HStack {
                    Text("Currency:")
                    Spacer()
                    Picker("Currency", selection: $currency) {
                        ForEach(availableCurrencies, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.menu).disabled(editMode)
                }.padding()
                HStack {
                    Text("Amount")
                    Spacer()
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }.padding()
            }
            Section("Occurrence") {
                HStack {
                    Text("Unit:")
                    Spacer()
                    Picker("Unit", selection: $frequencyUnit) {
                        Text(FrequencyUnit.day.rawValue).tag(FrequencyUnit.day)
                        Text(FrequencyUnit.hour.rawValue).tag(FrequencyUnit.hour)
                        Text(FrequencyUnit.minute.rawValue).tag(FrequencyUnit.minute)
                    }.pickerStyle(.menu)
                }.padding()
                HStack {
                    Text("Frequency:")
                    Spacer()
                    Picker("", selection: $frequencyValue) {
                        ForEach(availableFrequencies, id: \.number) {
                            Text($0.text).tag($0.number)
                        }
                    }
                }.padding()
            }
        }.navigationBarItems(trailing: Button(action: {
            Task.init {
                if (editMode) {
                    await savingsPlanController.editItem(savingsPlanId: self.savingsPlanId, updatedPlan: UpdateSavingsPlanPayload(amount: self.amount, frequencyUnit: self.frequencyUnit.rawValue, frequencyValue: self.frequencyValue))
                } else {
                    await savingsPlanController.addItem(SavingsPlan(tradingPair: self.tradingPair, amount: self.amount, currency: self.currency, platformName: self.platformId, platformDescription: "", frequencyUnit: self.frequencyUnit.rawValue, frequencyValue: self.frequencyValue, id: 0))
                }
                self.presentation.wrappedValue.dismiss()
                await self.reloadSavingsPlans()
            }
        }) {
            Text("Save")
        }.disabled(!(platformId != "" && tradingPair != "" && amount > 0.0 && frequencyValue > 0 && currency != "")))
        .navigationBarTitle("\(editMode ? "Edit" : "Create") Plan")
        .onAppear(perform: {
            if(platformId != "") {
                Task.init {
                    await platformMetaController.load(platformId: platformId)
                }
            }
        })
    }
}
