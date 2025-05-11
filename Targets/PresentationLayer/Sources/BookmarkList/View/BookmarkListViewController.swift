//
//  BookmarkListViewController.swift
//  PresentationLayer
//
//  Created by 이원빈 on 5/8/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import MozipCore
import DesignSystem
import DomainLayer
import UIKit

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa
import RxDataSources

final class BookmarkListViewController: BaseViewController<BookmarkListReactor>,
                                        Coordinatable,
                                        Alertable {
  
  private enum Metric {
    static let tableViewRowHeight: CGFloat = 95
  }
  
  // MARK: - Properties
  weak var coordinator: BookmarkListCoordinator?
  
  // MARK: UI 컴포넌트
  private let navigationBar: MozipNavigationBar
  private let tableView = UITableView(frame: .zero)
  private let emptyLabel = MozipLabel(
    style: .body3,
    color: MozipColor.gray400,
    text: "북마크한 공고가 존재하지 않습니다."
  )
  
  
  // MARK: - Initializer
  init(reactor: BookmarkListReactor) {
    navigationBar = .init(title: "북마크", backgroundColor: .white)
    super.init()
    
    self.reactor = reactor
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    coordinator?.disappear()
  }
  
  // MARK: - LifeCycle
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    navigationBar.pin.top().left().right()
    navigationBar.layer.applyShadow(color: .black, alpha: 0.04, x: 0, y: 4, blur: 8, spread: 0)
    tableView.pin.top(to: navigationBar.edge.bottom).left().right().bottom(view.safeAreaInsets)
    emptyLabel.pin.center().sizeToFit()
  }
  
  // MARK: - Methods
  override func bind(reactor: BookmarkListReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  override func setupViews() {
    view.backgroundColor = .white
    view.addSubview(tableView)
    view.addSubview(navigationBar)
    view.addSubview(emptyLabel)
    setupTableView()
  }
  
  func setupTableView() {
    tableView.register(BookmarkCell.self)
    tableView.rowHeight = Metric.tableViewRowHeight
  }
}

// MARK: - Private Extenion
private extension BookmarkListViewController {
  
  // MARK: Properties
  typealias Action = BookmarkListReactor.Action
  
  // MARK: Methods
  func bindAction(reactor: BookmarkListReactor) {
    rx.viewWillAppear
      .map { Action.fetchBookmarkList }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: BookmarkListReactor) {
    reactor.state
      .map { $0.bookmarkList }
      .filter { $0.isEmpty == false }
      .distinctUntilChanged()
      .bind(to: tableView.rx.items(
        cellIdentifier: BookmarkCell.defaultReuseIdentifier,
        cellType: BookmarkCell.self
      )) { row, element, cell in
        cell.setData(element)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.bookmarkList.isEmpty == false }
      .distinctUntilChanged()
      .bind(to: emptyLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .asSignal(onErrorJustReturn: false)
      .emit { isLoading in
        isLoading ? LoadingIndicator.start(withDimming: false) : LoadingIndicator.stop()
      }
      .disposed(by: disposeBag)
  }
  
  func bind() {
    navigationBar.backButtonTapObservable
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.coordinator?.didFinish()
      })
      .disposed(by: disposeBag)
    
    // MARK: TableView 설정
    tableView.rx.itemSelected
      .subscribe(with: self) { owner, indexPath in
        owner.tableView.deselectRow(at: indexPath, animated: true)
      }
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(BookmarkCellData.self)
      .subscribe(with: self) { owner, model in
        owner.coordinator?.pushPostDetail(id: model.id)
      }
      .disposed(by: disposeBag)
  }
}
