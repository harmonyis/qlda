import UIKit
struct Number {
    static let formatterWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}
extension Double {
    var doubleToString: String {
        let doubleRound = (self * 1000).rounded() / 1000
        var arrDouble = String(doubleRound).components(separatedBy: ".")
        let dou = Double(arrDouble[0])
        var doubleFormat = Number.formatterWithSeparator.string(from: NSNumber(value: dou!)) ?? ""
        
        if arrDouble[1] != "0" && arrDouble[1] != ""{
            if arrDouble[1].characters.count<4 {
                doubleFormat = doubleFormat + "," + arrDouble[1]
            }
            else
            {
                doubleFormat = doubleFormat + "," + arrDouble[1][0]  + arrDouble[1][1]  + arrDouble[1][2]
            }
        }
        return doubleFormat
    }
}
