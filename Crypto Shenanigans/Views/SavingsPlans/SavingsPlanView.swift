import SwiftUI

struct SavingsPlanView: View {

    var data: SavingsPlan
    
    static func generateFrequencyText(frequencyUnit: String, frequencyValue: Int) throws -> String {
        return "every\(frequencyValue > 1 ? " \(frequencyValue)" : "") \(frequencyUnit)\(frequencyValue > 1 ? "s" : "")"
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(data.tradingPair).font(.headline)
                Spacer()
                Text(data.platformDescription)
            }
            Spacer()
            HStack {
                Text("\(Mapper.formatDoubleToString(data.amount)) \(data.currency)")
                Spacer()
                Text((try? SavingsPlanView.generateFrequencyText(frequencyUnit: data.frequencyUnit, frequencyValue: data.frequencyValue)) ?? "")
            }
        }.padding()
    }
}

struct SavingsPlan_Preview: PreviewProvider {
    static var savingsPlan = SavingsPlan(tradingPair: "ETH/CAD", amount: 0.001, currency: "CAD", platformName: "ndax", platformDescription: "NDAX", frequencyUnit: "hour", frequencyValue: 2, id: 1)
    
    static var previews: some View {
        SavingsPlanView(data: savingsPlan)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

