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
import RxDataSources

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    private static let cellIdentifier: String = "PlayListTableViewCell"
    
    lazy var items: [String] = []
    let viewModel: PlaylistViewModel
    let id: String?
    
    private var bindHandler: (()->())?
    private var reloadHandler: (()->())?
    
    let disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder)")
    }
    
    init(type: ViewControllerType, id: String? = nil) {
        self.id = id
        self.viewModel = PlaylistViewModel(id)
        super.init(nibName: "PlaylistViewController", bundle: nil)
        bindHandler = {
            switch type {
            case .playlist:
                self.setupPlayList()
                self.viewModel.getPlayList()
            case .tracks:
                self.setupTrackList(false)
                self.viewModel.getTrackList()
            case .favorite:
                self.setupTrackList(true)
            }
        }
        
        reloadHandler = { [weak self] in
            switch type {
            case .playlist:
                break
            case .tracks:
                break
            case .favorite:
                self?.viewModel.getFavorite()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        setupLayout()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadHandler?()
    }
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionListModel>(
        configureCell: { (_, tableView, indexPath, repository) in
            let contentCell = tableView.dequeueReusableCell(withIdentifier: PlaylistViewController.cellIdentifier, for: indexPath) as! PlaylistTableViewCell
            contentCell.titleLabel.text = repository.title
            if let imageURL: String = repository.imageUrl {
                contentCell.iconImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
            }
            return contentCell
    }, titleForHeaderInSection: { dataSource, sectionIndex in
        return dataSource[sectionIndex].model
    })
}

extension PlaylistViewController: ViewControllerFlowProtocol {
    func setupNavigation() {
        navigationController?.navigationBar.isTranslucent = false
    }
    private func setupUI() {
        contentTableView.register(UINib(nibName: "PlaylistTableViewCell", bundle: nil), forCellReuseIdentifier: PlaylistViewController.cellIdentifier)
        contentTableView.estimatedRowHeight = 100
        contentTableView.rowHeight = UITableView.automaticDimension
    }
    private func setupLayout() {
        contentTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    private func binding() {
        viewModel.output.dataList.drive(contentTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        bindHandler?()
    }
    
    private func setupPlayList() {
        contentTableView.rx
            .modelSelected(PlayListModel.self)
            .subscribe(onNext: { [weak self] item in
                let controller = PlaylistViewController(type: .tracks, id: item.id)
                controller.title = item.title
                controller.hidesBottomBarWhenPushed = true
                self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: nil)
                self?.navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setupTrackList(_ local: Bool) {
        contentTableView.rx
            .modelSelected(TracksListModel.self)
            .subscribe(onNext: { [weak self] item in
            let controller: AlbumViewController = AlbumViewController(resource: item)
            self?.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
    }
}
