import UIKit
import Yosemite
import XLPagerTabStrip
import WordPressShared
import CocoaLumberjack


class PeriodDataViewController: UIViewController, IndicatorInfoProvider {

    // MARK: - Properties

    @IBOutlet private weak var visitorsTitle: UILabel!
    @IBOutlet private weak var visitorsData: UILabel!
    @IBOutlet private weak var ordersTitle: UILabel!
    @IBOutlet private weak var ordersData: UILabel!
    @IBOutlet private weak var revenueTitle: UILabel!
    @IBOutlet private weak var revenueData: UILabel!
    @IBOutlet private weak var lastUpdated: UILabel!
    @IBOutlet private weak var chartView: UIView!
    @IBOutlet private weak var borderView: UIView!
    private var lastUpdatedDate: Date?

    public let granularity: StatGranularity
    public var orderStats: OrderStats? {
        didSet {
            lastUpdatedDate = Date()
            reloadOrderFields()
            reloadLastUpdatedField()
        }
    }
    public var siteStats: SiteVisitStats? {
        didSet {
            lastUpdatedDate = Date()
            reloadSiteFields()
            reloadLastUpdatedField()
        }
    }

    // MARK: - Computed Properties

    private var summaryDateUpdated: String {
        if let lastUpdatedDate = lastUpdatedDate {
            return String.localizedStringWithFormat(NSLocalizedString("Updated %@.",
                                                                      comment: "Stats summary date"), lastUpdatedDate.mediumString())
        } else {
            return ""
        }
    }
    
    // MARK: - Initialization

    /// Designated Initializer
    ///
    init(granularity: StatGranularity) {
        self.granularity = granularity
        super.init(nibName: type(of: self).nibName, bundle: nil)
    }

    /// NSCoder Conformance
    ///
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadAllFields()
    }
}


// MARK: - IndicatorInfoProvider Confromance
//
extension PeriodDataViewController {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: granularity.pluralizedString)
    }
}


// MARK: - User Interface Configuration
//
private extension PeriodDataViewController {

    func configureView() {
        view.backgroundColor = .white
        borderView.backgroundColor = StyleManager.wooGreyBorder

        // Titles
        visitorsTitle.font = UIFont.footnote
        visitorsTitle.textColor = StyleManager.defaultTextColor
        ordersTitle.font = UIFont.footnote
        ordersTitle.textColor = StyleManager.defaultTextColor
        revenueTitle.font = UIFont.footnote
        revenueTitle.textColor = StyleManager.defaultTextColor

        // Data
        visitorsData.font = StyleManager.statsBigDataFont
        visitorsData.textColor = StyleManager.defaultTextColor
        ordersData.font = StyleManager.statsBigDataFont
        ordersData.textColor = StyleManager.defaultTextColor
        revenueData.font = StyleManager.statsBigDataFont
        revenueData.textColor = StyleManager.defaultTextColor

        // Footer
        lastUpdated.font = UIFont.footnote
        lastUpdated.textColor = StyleManager.wooGreyMid
    }
}


// MARK: - Private Helpers
//
private extension PeriodDataViewController {

    func reloadAllFields() {
        reloadOrderFields()
        reloadSiteFields()
        reloadLastUpdatedField()
    }

    func reloadOrderFields() {
        // FIXME: This is really just WIP  code which puts data in the fields. Refactor please.
        let totalOrders = orderStats?.totalOrders ?? 0
        let currencySymbol = orderStats?.currencySymbol ?? ""
        if ordersData != nil { ordersData.text = String(totalOrders) }
        let totalRevenue = orderStats?.totalGrossSales ?? Double(0)
        if revenueData != nil { revenueData.text = "\(currencySymbol)\(totalRevenue.friendlyString())" }
    }

    func reloadSiteFields() {
        // FIXME: This is really just WIP  code which puts data in the fields. Refactor please.
        let totalVisitors = siteStats?.totalVisitors ?? 0
        if visitorsData != nil { visitorsData.text = String(totalVisitors) }
    }

    func reloadLastUpdatedField() {
        if lastUpdated != nil { lastUpdated.text = summaryDateUpdated }
    }
}
