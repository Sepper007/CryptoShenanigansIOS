import SwiftUI

struct TradeItem: View  {
    
    var data: MyTradesResponse
    
    private let dateFormatter: DateFormatter
    
    init (data: MyTradesResponse) {
        self.data = data
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName:"arrowshape.turn.up.\(data.side == "buy" ? "right" : "left").circle")
                .font(.system(size: 25))
                .foregroundColor(data.side == "buy" ? .green: .red)
            VStack(alignment: .leading) {
                HStack {
                    Text("+ \(Mapper.formatDoubleToString(data.side == "buy" ? data.volume: data.value))")
                    Text(data.symbol.split(separator: "/")[data.side == "buy" ? 0 : 1])
                        .font(.system(size: 15, weight: .heavy))
                }
                Spacer()
                HStack {
                    Text("- \(Mapper.formatDoubleToString(data.side == "buy" ? data.value: data.volume))")
                    Text(data.symbol.split(separator: "/")[data.side == "buy" ? 1 : 0])
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(Mapper.formatDoubleToString(data.price)) \(data.symbol)")
                Spacer()
                Text(data.datetime)
            }
        }.font(.system(size: 15))
        .padding(.bottom, 5)
        .padding(.top, 5)
    }
}

struct TradeItem_Preview: PreviewProvider {
    private static var resp = MyTradesResponse(symbol: "ETH/CAD", side: "buy", type: "market", volume: 0.1, price: 5100.5, value: 510.05, datetime: "2021/11/26 16:06")
    
    static var previews: some View {
        TradeItem(data: resp)
    }
}
