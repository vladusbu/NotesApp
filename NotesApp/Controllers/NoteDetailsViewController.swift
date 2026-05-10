//
//  NoteDetailsViewController.swift
//  NotesApp
//
//  Created by Vlad on 02.05.2026.
//



import UIKit


class NoteDetailsViewController: UIViewController {
    
    var note: Note?
    
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
        return tf
    }()

    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIConstant.Fonts.descriptionNoteTextView
        tv.textColor = .black
        tv.backgroundColor = .clear
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить" ,
            style: .plain ,
            target: self,
            action: #selector(saveTapped)
        )
        
        
        view.addSubview(titleTF)
        view.addSubview(descriptionTextView)
        
        
        titleTF.text = note?.title
        descriptionTextView.text = note?.description
        
        
        NSLayoutConstraint.activate([
            titleTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTF.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20) ,
            descriptionTextView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descriptionTextView.becomeFirstResponder()
    }
}


extension NoteDetailsViewController  {
    
    @objc func saveTapped() {
        guard let note else { return }
        print("Tap Button: \(note.description )")
        service.updateNotes(
            note: note,
            title: titleTF.text ?? "",
            text: descriptionTextView.text ?? "",
            Date(),
            note.pinImage ?? "")
        
        

        navigationController?.popViewController(animated: true)
    }
    
}
