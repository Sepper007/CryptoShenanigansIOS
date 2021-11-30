import Foundation

struct Mapper {
    static func formatDoubleToString (_ val: Double, numberOfDigits: Int = 3) -> String {
        
        let floatingDigits: Int
        
        if (val > 1.0 || val.remainder(dividingBy: 1.0) == 0.0) {
            // If amount is bigger than 1, cut off after 2 digits
            floatingDigits = numberOfDigits - 1
        } else {
            let str = String(format:"%f", val)
            
            if (!str.contains(".")) {
                return str
            }
            
            let subStrings = str.components(separatedBy: ".")
            
            var index = 0
            
            for char in subStrings[1] {
                if (char != "0") {
                    break
                }
                index += 1
            }
            
            floatingDigits = index + numberOfDigits
        }
        
        return String(format: "%.\(floatingDigits)f", val)
    }
}
