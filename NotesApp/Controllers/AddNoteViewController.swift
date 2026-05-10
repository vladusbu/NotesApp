//
//  Untitled.swift
//  NotesApp
//
//  Created by Vlad on 07.05.2026.
//



import UIKit


class AddNoteViewController: UIViewController {
    
    private var debounceTimer: Timer?
    private let service: NoteService
    
    init(service: NoteService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private let titleTF: UITextField = {
        let tf = UITextField()
        
        tf.font = UIConstant.Fonts.titleNoteTF
        tf.textColor = .black
        tf.borderStyle = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.attributedPlaceholder = NSAttributedString(
            string: "Заголовок",
            attributes: [
                .foregroundColor: UIColor.getColor(120, 174, 180, 0.34),
                .font: UIConstant.Fonts.titleAddNote
            ]
        )
        
        return tf
    }()
    
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIConstant.Fonts.descriptionNoteTextView
        tv.textColor = .black
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.textContainerInset = UIEdgeInsets(top: 2, left: -5, bottom: 0, right: 0)
        tv.textContainer.lineFragmentPadding = 0
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Начните писать"
        label.textColor = UIColor.getColor(120, 174, 180, 0.34)
        label.font = UIConstant.Fonts.descriptionAddNote
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var saveBtn = makeButton(
        image: "check 1",
        action: #selector(tapSave),
        target: self
    )
    
    private lazy var pinBtn = makeButton(
        image: "pin",
        action: #selector(tapPin),
        target: self
    )
    
    
    private lazy var horizontalStackView: UIStackView = {
        let cancelBtn = makeButton(image: "close 1", action: #selector(tapCancel), target: self)
        
        let hStack = UIStackView(arrangedSubviews: [cancelBtn , pinBtn , saveBtn])
        hStack.axis = .horizontal
        
        hStack.setCustomSpacing(222, after: cancelBtn)
        hStack.setCustomSpacing(25, after: pinBtn)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        return hStack
    }()
    
    private lazy var verticalStackView: UIStackView = {
        
        let stack = UIStackView(arrangedSubviews: [
            titleTF,
            descriptionTextView
        ])
        
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    var selectedPinImage: String? = nil
    private var isPinned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        saveBtn.alpha = 0.34
        pinBtn.setImage(UIImage(named: "pin 1"),for: .normal)
        
        titleTF.delegate = self
        descriptionTextView.delegate = self

       
        titleTF.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        view.addSubview(separatorView)
        view.addSubview(verticalStackView)
        view.addSubview(horizontalStackView)
        descriptionTextView.addSubview(placeholderLabel)
        
        setupUI()
        
    }
    
    
    private func setupUI() {
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor) ,
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor) ,
            separatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 63) ,
            separatorView.heightAnchor.constraint(equalToConstant: 1) ,
           
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33) ,
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65) ,
            horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24) ,
            horizontalStackView.heightAnchor.constraint(equalToConstant: 21) ,
            
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19) ,
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19) ,
            verticalStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 14) ,
            
            descriptionTextView.heightAnchor.constraint(equalToConstant: 200) ,
            
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor , constant: 2),
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 2)
        ])
    }
    
    
    
    
    func makeButton(image: String ,
                    tintColor: UIColor = .black ,
                    action: Selector ,
                    target: Any)
    -> UIButton {
        
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: image)?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.tintColor = tintColor
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }
    
}




extension AddNoteViewController: UITextFieldDelegate , UITextViewDelegate {
    
    
    //MARK: - UIButton
    @objc func tapCancel() {
        dismiss(animated: true)
    }
    
    @objc func tapPin() {
        selectedPinImage = selectedPinImage == nil ? "thumbtacks 1" : nil
        isPinned.toggle()
        
        let imageName = isPinned ? "thumbtacks 1" : "pin 1"
        
        pinBtn.setImage(
            UIImage(named: imageName),
            for: .normal
        )
        
    }
    
    @objc func tapSave() {
        guard !(titleTF.text ?? "").isEmpty && !(descriptionTextView.text ?? "").isEmpty else {
            return
        }
        
        let note = Note(
            id: UUID(), title: self.titleTF.text ?? "",
            description: self.descriptionTextView.text ?? "",
            pinImage: selectedPinImage ,
            date: Date()
        )
        
        service.saveNotes(note)
        
        dismiss(animated: true)
    }
    
    //MARK: - UITextField
    @objc func textDidChange() {
        
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let hasText = !(titleTF.text ?? "").isEmpty && !(descriptionTextView.text ?? "").isEmpty
        saveBtn.isEnabled = hasText
        saveBtn.alpha = hasText ? 1.0 : 0.34
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updateText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updateText.count <= 40
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        textDidChange()
    }
}
