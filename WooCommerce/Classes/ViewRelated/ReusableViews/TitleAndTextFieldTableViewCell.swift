import UIKit

/// Contains a title label and a text field.
///
final class TitleAndTextFieldTableViewCell: UITableViewCell {
    struct ViewModel {
        let title: String?
        let text: String?
        let placeholder: String?
        let onTextChange: ((_ text: String?) -> Void)?

        init(title: String?, text: String?, placeholder: String?, onTextChange: ((_ text: String?) -> Void)?) {
            self.title = title
            self.text = text
            self.placeholder = placeholder
            self.onTextChange = onTextChange
        }
    }

    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!

    private var onTextChange: ((_ text: String?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        configureSelectionStyle()
        configureTitleLabel()
        configureTextField()
        configureContentStackView()
        applyDefaultBackgroundStyle()
    }

    func configure(viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        textField.text = viewModel.text
        textField.placeholder = viewModel.placeholder
        onTextChange = viewModel.onTextChange
    }
}

private extension TitleAndTextFieldTableViewCell {
    func configureSelectionStyle() {
        selectionStyle = .none
    }

    func configureTitleLabel() {
        titleLabel.applyBodyStyle()
    }

    func configureTextField() {
        textField.applyBodyStyle()
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    func configureContentStackView() {
        contentStackView.spacing = 30
    }
}

private extension TitleAndTextFieldTableViewCell {
    @objc func textFieldDidChange(textField: UITextField) {
        onTextChange?(textField.text)
    }
}
