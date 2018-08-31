import Foundation
import Yosemite


// MARK: - OrderStats Helper Methods
//
extension OrderStats {

    /// Returns the Currency Symbol associated with the current order stats.
    ///
    var currencySymbol: String {
        guard let currency = items?.filter({ !$0.currency.isEmpty }).first?.currency else {
            return ""
        }
        guard let identifier = Locale.availableIdentifiers.first(where: { Locale(identifier: $0).currencyCode == currency }) else {
            return currency
        }

        return Locale(identifier: identifier).currencySymbol ?? currency
    }

    /// Returns the sum of total sales this stats period. This value is typically used in the dashboard for revenue reporting.
    ///
    /// *Note:* The value returned here is an aggregation of all the `OrderStatsItem.totalSales` values and
    /// _not_ `OrderStats.totalGrossSales` or `OrderStats.totalNetSales`.
    ///
    var totalSales: Double {
        return items?.map({ $0.totalSales }).reduce(0.0, +) ?? 0.0
    }
}