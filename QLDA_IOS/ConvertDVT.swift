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
        var doubleRound = (self * 1000).rounded() / 1000
        var arrDouble = String(doubleRound).components(separatedBy: ".")
        var dou = Double(arrDouble[0])
        var doubleFormat = Number.formatterWithSeparator.string(from: NSNumber(value: dou!)) ?? ""
        if arrDouble[1] != "0" || arrDouble[1] != ""{
            doubleFormat = doubleFormat + "," + arrDouble[1]
        }
        return doubleFormat
    }
}


