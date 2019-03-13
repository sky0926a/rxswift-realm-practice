//
//  AlbumViewController.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/11.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class AlbumViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistTitleLabel: UILabel!
    @IBOutlet weak var artistContentLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumContentLabel: UILabel!
    
    let resource: TracksListModel
    var fellowButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setTitle("Like", for: .normal)
        button.setTitle("Unlike", for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    let disposeBag = DisposeBag()
    let viewModel: AlbumViewModel
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder)")
    }
    
    init(resource: TracksListModel) {
        self.resource = resource
        self.viewModel = AlbumViewModel(model: resource)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        setupLayout()
        binding()
    }

}

extension AlbumViewController: ViewControllerFlowProtocol {
    func setupUI() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        artistContentLabel.numberOfLines = 0
        albumContentLabel.numberOfLines = 0
        artistTitleLabel.text = "Artist:"
        albumTitleLabel.text = "Album:"
    }
    func setupLayout() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(30)
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
            make.centerX.equalTo(view.snp.centerX)
        }
        albumImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.width.height.equalTo(view.snp.width).multipliedBy(0.5)
            make.centerX.equalTo(view.snp.centerX)
        }
        artistTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(albumImageView.snp.bottom).offset(20)
            make.right.equalTo(albumImageView.snp.left).offset(-10)
        }
        artistContentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artistTitleLabel.snp.top)
            make.left.equalTo(albumImageView.snp.left)
            make.right.equalTo(albumImageView.snp.right).offset(30)
        }
        albumTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artistContentLabel.snp.bottom).offset(20)
            make.right.equalTo(albumImageView.snp.left).offset(-10)
        }
        albumContentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(albumTitleLabel.snp.top)
            make.left.equalTo(albumImageView.snp.left)
            make.right.equalTo(albumImageView.snp.right).offset(30)
        }
        fellowButton.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
    }
    func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: fellowButton)
        navigationController?.navigationBar.isTranslucent = false
    }
    func binding() {
        viewModel.output.titleText.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.titleText.drive(navigationItem.rx.title).disposed(by: disposeBag)
        viewModel.output.albumText.drive(albumContentLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.artistText.drive(artistContentLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.albumURL.asObservable().bind { [weak self] (imageUrl) in
            self?.albumImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }.disposed(by: disposeBag)
        viewModel.output.isFavorited.drive(fellowButton.rx.isSelected).disposed(by: disposeBag)
        fellowButton.rx.tap.subscribe(viewModel.fellowTap).disposed(by: disposeBag)
    }
}
