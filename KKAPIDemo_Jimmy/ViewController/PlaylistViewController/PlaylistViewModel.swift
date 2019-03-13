//
//  PlaylistViewModel.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/8.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

typealias SectionListModel = SectionModel<String, ObjectProtocol>

class PlaylistViewModel: NSObject {
    
    typealias Input = PlaylistInput
    typealias Output = PlaylistOutput
    
    var input: Input
    var output: Output
    
    struct PlaylistInput {
        let id: String?
    }
    
    struct PlaylistOutput {
        let dataList: Driver<[SectionListModel]>
    }
    
    private let dataListRelay: BehaviorRelay<[SectionListModel]> = BehaviorRelay(value: [])
    
    init(_ id: String? = nil) {
        self.input = Input(id: id)
        self.output = Output(dataList: dataListRelay.asDriver())
    }
    
    func getPlayList() {
        let fetch: Single<PlayList> = User.current.fetchPlayList()
        _ = fetch.subscribe(onSuccess: { [weak self] (list) in
//            _ = RealmManager.db.add(list.data)
            self?.dataListRelay.accept([SectionModel.init(model: "PlayList", items: list.data)])
        }, onError: nil)
    }
    
    func getTrackList() {
        let fetch: Single<TracksModel> = User.current.fetchPlayList(input.id)
        _ = fetch.subscribe(onSuccess: { [weak self] (list) in
//            _ = RealmManager.db.add(list.tracks.data)
            self?.dataListRelay.accept([SectionModel.init(model: "Tracks", items: list.tracks.data)])
            }, onError: nil)
    }
    
    func getFavorite() {
        let result: Results<TracksListModel> = RealmManager.db.query().filter("isFavorited = true")
        let models: [TracksListModel] = result.map({ (result) -> TracksListModel in
            return result
        })
        self.dataListRelay.accept([SectionModel.init(model: "Favorite", items: models)])
    }
}
