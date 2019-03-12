import Foundation
import Alamofire


/// ShipmentsRemote: Remote Endpoints
///
public final class ShipmentsRemote: Remote {

    /// Retrieves all of the shipment tracking info for a given order.
    ///
    /// - Parameters:
    ///   - siteID: Site which hosts the Order
    ///   - orderID: Identifier of the Order
    ///   - completion: Closure to be executed upon completion
    ///
    public func loadShipmentTrackings(for siteID: Int, orderID: Int, completion: @escaping ([ShipmentTracking]?, Error?) -> Void) {
        let path = "\(Constants.ordersPath)/" + String(orderID) + "/" + "\(Constants.shipmentPath)/"

        // 2019-2-15 — We are using the v2 endpoint here because this endpoint does not support v3 yet
        let request = JetpackRequest(wooApiVersion: .mark2, method: .get, siteID: siteID, path: path, parameters: nil)
        let mapper = ShipmentTrackingListMapper(siteID: siteID, orderID: orderID)

        enqueue(request, mapper: mapper, completion: completion)
    }

    public func createShipmentTracking(for siteID: Int, orderID: Int, trackingProvider: String, trackingNumber: String, completion: @escaping (ShipmentTracking?, Error?) -> Void) {
        let path = "\(Constants.ordersPath)/" + String(orderID) + "/" + "\(Constants.shipmentPath)/"

        let parameters = [ParameterKeys.trackingNumber: trackingNumber,
                          ParameterKeys.trackingProvider: trackingProvider]

        let request = JetpackRequest(wooApiVersion: .mark2, method: .post, siteID: siteID, path: path, parameters: parameters)
        let mapper = NewShipmentTrackingMapper(siteID: siteID, orderID: orderID)

        enqueue(request, mapper: mapper, completion: completion)
    }

    public func createShipmentTrackingWithCustomProvider(for siteID: Int, orderID: Int, trackingProvider: String, trackingNumber: String, trackingLink: String, completion: @escaping (ShipmentTracking?, Error?) -> Void) {
        let path = "\(Constants.ordersPath)/" + String(orderID) + "/" + "\(Constants.shipmentPath)/"

        let parameters = [ParameterKeys.trackingNumber: trackingNumber,
                          ParameterKeys.customTrackingLink: trackingLink,
                          ParameterKeys.customTrackingProvider: trackingProvider]

        let request = JetpackRequest(wooApiVersion: .mark2, method: .post, siteID: siteID, path: path, parameters: parameters)
        let mapper = NewShipmentTrackingMapper(siteID: siteID, orderID: orderID)

        enqueue(request, mapper: mapper, completion: completion)
    }
}


// MARK: - Constants!
//
private extension ShipmentsRemote {

    enum Constants {
        static let ordersPath: String   = "orders"
        static let shipmentPath: String = "shipment-trackings"
    }

    enum ParameterKeys {
        static let customTrackingLink: String     = "custom_tracking_link"
        static let customTrackingProvider: String = "custom_tracking_provider"
        static let trackingNumber: String         = "tracking_number"
        static let trackingProvider: String       = "tracking_provider"
    }
}
