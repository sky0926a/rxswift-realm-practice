//
//  ViewController.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/4.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SDWebImage

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    private let cellIdentifier: String = "PlayListTableViewCell"
    
    lazy var items: [String] = []
    var viewModel: ViewModel = ViewModel()
    let disposeBag = DisposeBag()
    var id: String?
    
//    convenience init(id: String) {
//        super.init(nibName: nil, bundle: nil)
//
//
//    }

//    required init?(coder aDecoder: NSCoder) {
//        self.viewModel = ViewModel()
//        super.init(coder: aDecoder)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initMethod()
    }
}

extension PlaylistViewController: ViewControllerFlowProtocol {
    func initMethod() {
        viewModel.data.bind(to: contentTableView.rx.items(cellIdentifier: cellIdentifier)) {_, repository, cell in
            let contentCell: PlaylistTableViewCell = cell as! PlaylistTableViewCell
            contentCell.titleLabel.text = repository.title
            if let imageURL: String = repository.images.first as? String {
                contentCell.iconImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
            }
            }.disposed(by: disposeBag)
        contentTableView.rx.modelSelected(Playlist.self).subscribe(onNext: {item in
            print("selected id info : \(item.id)")
            let controller: PlaylistViewController = PlaylistViewController()//(id: item.id)
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            
        }).disposed(by: disposeBag)
        
    }
    func setupNavigation() {
        navigationItem.title = "PlayList"
    }
    func setupUI() {
        contentTableView.register(UINib(nibName: "PlaylistTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        contentTableView.estimatedRowHeight = 100
        contentTableView.rowHeight = UITableView.automaticDimension
    }
    func setupLayout() {
        contentTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}
