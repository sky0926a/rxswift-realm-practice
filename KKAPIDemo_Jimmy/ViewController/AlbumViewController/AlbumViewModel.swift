//
//  AlbumViewModel.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/12.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class AlbumViewModel {
    
    typealias Input = AlbumInput
    typealias Output = AlbumOutput
    
    var input: Input
    var output: Output
    
    struct AlbumInput {
        let model: TracksListModel
    }
    
    struct AlbumOutput {
        let titleText: Driver<String>
        let albumText: Driver<String>
        let artistText: Driver<String>
        var albumURL: Driver<String>
        var isFavorited: Driver<Bool>
    }
    
    private let titleTextRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let albumTextRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let artistTextRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let albumURLRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let isFavoritedRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let fellowTap = PublishSubject<Void>()
    
    init(model: TracksListModel) {
        self.input = Input(model: model)
        self.output = Output(titleText: titleTextRelay.asDriver(),
                                  albumText: albumTextRelay.asDriver(),
                                  artistText: artistTextRelay.asDriver(),
                                  albumURL: albumURLRelay.asDriver(),
                                  isFavorited: isFavoritedRelay.asDriver())
        transform()
    }
    
    func transform() {
        titleTextRelay.accept(input.model.title)
        albumTextRelay.accept(input.model.album.name)
        artistTextRelay.accept(input.model.album.artist.name)
        albumURLRelay.accept(input.model.imageUrl ?? "")
        let isFavorited: Bool = self.convertFavorited()
        isFavoritedRelay.accept(isFavorited)
        _ = fellowTap.bind { [weak self] (_) in
            if let weakself = self {
                let status = !weakself.isFavoritedRelay.value
                weakself.updateSelectedResult(with: status, handler: { (result) in
                    weakself.isFavoritedRelay.accept(status)
                })
            }
        }
    }
    
    func fetchFollowObject(by model: TracksListModel) -> TracksListModel? {
        let result: Results<TracksListModel> = RealmManager.db.query().filter("id = %@", input.model.id)
        return result.elements.first
    }
    
    func convertFavorited() -> Bool {
        return fetchFollowObject(by: input.model)?.isFavorited ?? false
    }
    
    func updateSelectedResult(with status: Bool, handler: RealmHandler?){
        RealmManager.db.update(write: { (db) in
            input.model.isFavorited = status
        }, handler: handler)
    }
}
