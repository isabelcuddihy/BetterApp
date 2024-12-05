//
//  ChatsTableView.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
// TD: work on safe deleting this

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelConversationName: UILabel!
    var labelName: UILabel!
    var labelMessageSent: UILabel!
    var labelTimeStamp: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelConversationName()
        setupLabelName()
        setupLabelMessageSent()
        setupLabelTimeStamp()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelConversationName(){
        labelConversationName = UILabel()
        labelConversationName.font = UIFont.boldSystemFont(ofSize: 20)
        labelConversationName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelConversationName)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 14)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    
    func setupLabelMessageSent(){
        labelMessageSent = UILabel()
        labelMessageSent.font = UIFont.boldSystemFont(ofSize: 14)
        labelMessageSent.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelMessageSent)
    }
    
    func setupLabelTimeStamp(){
        labelTimeStamp = UILabel()
        labelTimeStamp.font = UIFont.boldSystemFont(ofSize: 14)
        labelTimeStamp.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTimeStamp)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            labelConversationName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant:  4),
            labelConversationName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelConversationName.heightAnchor.constraint(equalToConstant: 20),
            labelConversationName.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            
            labelName.topAnchor.constraint(equalTo: labelConversationName.bottomAnchor, constant:  2),
            labelName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelName.heightAnchor.constraint(equalToConstant: 16),
            labelName.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            
            labelMessageSent.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 2),
            labelMessageSent.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelMessageSent.heightAnchor.constraint(equalToConstant: 16),
            labelMessageSent.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            
            labelTimeStamp.topAnchor.constraint(equalTo: labelMessageSent.bottomAnchor, constant: 2),
            labelTimeStamp.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelTimeStamp.heightAnchor.constraint(equalToConstant: 16),
            labelTimeStamp.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
