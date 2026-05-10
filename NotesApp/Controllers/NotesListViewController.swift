//
//  ViewController.swift
//  NotesApp
//
//  Created by Vlad on 02.05.2026.
//

import UIKit

class NotesListViewController: UIViewController {
    
    let tableView = UITableView()
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let service: NoteService
    
    init(service: NoteService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    private var notes: [Note] = []
    private var filteredNotes: [Note] = []
    private var isSearching = false
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add 1")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.text = ""
        tf.borderStyle = .none
        
        tf.attributedPlaceholder = NSAttributedString(
            string: "Поиск Заметок",
            attributes: [
                .foregroundColor: UIColor.getColor(93, 163, 190, 0.34) ,
                .font: UIConstant.Fonts.placeholder
            ]
        )

        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .black
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: 15, y: 0, width: 16, height: 16)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 16))
        container.addSubview(icon)

        tf.leftView = container
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        notes = service.getNotes()
        filteredNotes = notes
        searchTextField.delegate = self
        addButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        
        
        setupHeader()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        notes = service.getNotes()
        filteredNotes = notes
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
    }
    
    func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        titleLabel.text = "Заметки"
        titleLabel.font = UIConstant.Fonts.navigationTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        

        headerView.addSubview(titleLabel)
        headerView.addSubview(addButton)
        headerView.addSubview(searchTextField)
        headerView.addSubview(separatorView)

            
        NSLayoutConstraint.activate([
            //heeaderView
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 134),
            //titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor , constant: 38),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor , constant: 24) ,
            //addButton
            addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor , constant: -23),
            addButton.topAnchor.constraint(equalTo: headerView.topAnchor , constant: 35),
            addButton.widthAnchor.constraint(equalToConstant: 25),
            addButton.heightAnchor.constraint(equalToConstant: 25),
            //searchTextField
            searchTextField.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 38) ,
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 23) ,
            //separatorView
            separatorView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)

        ])

    }
   
}





extension NotesListViewController:  UITableViewDataSource, UITableViewDelegate , UITextFieldDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredNotes.count : notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        
        let items = isSearching ? filteredNotes[indexPath.row] : notes[indexPath.row]
        
        cell.configure(with: items)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "delete") { _ , _ , completion in
            
           
            let items = self.notes[indexPath.row]
            self.service.deleteNotes(items)
            self.notes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        delete.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let noteDetailVc = NoteDetailsViewController(service: service)

        let selectedNote = isSearching
            ? filteredNotes[indexPath.row]
            : notes[indexPath.row]

        noteDetailVc.note = selectedNote

        navigationController?.pushViewController(noteDetailVc, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {return false}
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        filterNotes(query: updatedText)
        return true
    }
    
    
    @objc func addNote() {
        let addNoteVc = AddNoteViewController(service: service)
        addNoteVc.modalPresentationStyle = .fullScreen
        
        present(addNoteVc, animated: true)
        
    }
    
    func filterNotes(query: String) {
        if query.isEmpty {
            isSearching = false
            filteredNotes = notes
        } else {
            isSearching = true
            filteredNotes = notes.filter {
                $0.title.lowercased().contains(query.lowercased()) ||
                $0.description.lowercased().contains(query.lowercased())
            }
        }
        
        tableView.reloadData()
    }
}
