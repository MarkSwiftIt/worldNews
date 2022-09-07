//
//  NewsTableViewCell.swift
//  World News
//
//  Created by Mark Goncharov on 19.07.2022.
//
//

import UIKit


//MARK: - TableViewCell ViewModel

class NewsTableViewCellViewModel {
    
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String,
         subtitle: String,
         imageURL: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

//MARK: - TableViewCell

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
//MARK: - Label and Image
    
    private let newsTitleLable: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let subTitleLable: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFit
        return image
    }()
    
//MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsTitleLable)
        contentView.addSubview(subTitleLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - LayoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLable.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.frame.size.width - 170,
                                      height: 70
        )
        subTitleLable.frame = CGRect(x: 10,
                                     y: 70,
                                     width: contentView.frame.size.width - 170,
                                     height: contentView.frame.size.height/2
        )
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 150,
                                     y: 5,
                                     width: 140,
                                     height: contentView.frame.size.height - 10)
    }
    
//MARK: - Prepare
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsTitleLable.text = nil
        subTitleLable.text = nil
        newsImageView.image = nil
    }
    
//MARK: -Configure
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        
        newsTitleLable.text = viewModel.title
        subTitleLable.text = viewModel.subtitle
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL{
                
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
