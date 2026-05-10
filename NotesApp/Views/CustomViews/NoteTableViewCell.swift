//
//  TableViewCell.swift
//  NotesApp
//
//  Created by Vlad on 03.05.2026.
//



import UIKit


class NoteTableViewCell: UITableViewCell {
    
    //MARK: - UIelements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            
            // icon
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 21),
            iconImageView.heightAnchor.constraint(equalToConstant: 21),
            
            // date (справа сверху)
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            
            // title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            
            // description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
        ])
    }
    
    // MARK: - Configure
    
    func configure(with note: Note) {
        titleLabel.text = note.title
        descriptionLabel.text = note.description
        iconImageView.image = UIImage(named: note.pinImage ?? "note.text")
        
        dateLabel.text = note.date?.timeAgo()
    }
}
