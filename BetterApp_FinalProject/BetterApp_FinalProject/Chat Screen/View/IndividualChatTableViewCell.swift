//
//  IndividualChatTableViewCell.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//

import UIKit

class IndividualChatTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelSenderName: UILabel!
    var labelMessageSent: UILabel!
    var labelTimeStamp: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelSenderName()
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
    
    func setupLabelSenderName(){
        labelSenderName = UILabel()
        labelSenderName.font = UIFont.boldSystemFont(ofSize: 14)
        labelSenderName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelSenderName)
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
            wrapperCellView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            labelSenderName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 4),
            labelSenderName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelSenderName.heightAnchor.constraint(equalToConstant: 20),
            labelSenderName.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
          
            labelMessageSent.topAnchor.constraint(equalTo: labelSenderName.bottomAnchor, constant: 2),
            labelMessageSent.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelMessageSent.heightAnchor.constraint(equalToConstant: 20),
            labelMessageSent.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
                   
           
 
            labelTimeStamp.topAnchor.constraint(equalTo: labelMessageSent.bottomAnchor, constant: 2),
            labelTimeStamp.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelTimeStamp.heightAnchor.constraint(equalToConstant: 20),
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


