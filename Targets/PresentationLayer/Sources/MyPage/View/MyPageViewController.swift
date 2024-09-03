//
//  MyPageViewController.swift
//  PresentationLayer
//
//  Created by 한상진 on 2024/08/30.
//  Copyright © 2024 MOZIP. All rights reserved.
//

import DesignSystem
import DomainLayer
import UIKit

import PinLayout
import ReactorKit
import RxCocoa
import RxDataSources

final class MyPageViewController: BaseViewController<MyPageReactor>, Coordinatable, Alertable {
  
  // MARK: - Properties
  weak var coordinator: MyPageCoordinator?
  private let navigationBar: MozipNavigationBar
  
  private enum TableViewMetric: CaseIterable {
    static let rowHeight: CGFloat = 38
    static let sectionHeight: CGFloat = 20
    static let sectionBottomMargin: CGFloat = 20
    static let dividerViewHeight: CGFloat = 1
    static let dividerViewMargin: CGFloat = 64
    
    static var sectionAreaHeight: CGFloat {
      sectionHeight + sectionBottomMargin
    }
    
    static var sectionWithDividerAreaHeight: CGFloat {
      sectionAreaHeight + dividerViewHeight + dividerViewMargin
    }
  }
  
  private let tableView: UITableView = {
    let tableView: UITableView = .init()
    tableView.bounces = false
    tableView.separatorStyle = .none
    tableView.backgroundColor = .white
    tableView.rowHeight = TableViewMetric.rowHeight
    tableView.sectionHeaderTopPadding = 0
    tableView.register(MyPageTableViewCell.self)
    tableView.register(MyPageTableHeaderView.self)
    return tableView
  }()
  
  private lazy var tableViewCell = { [weak self] (indexPath: IndexPath) -> MyPageTableViewCell in
    guard let cell = self?.tableView.dequeueReusableCell(
      withIdentifier: MyPageTableViewCell.defaultReuseIdentifier,
      for: indexPath
    ) as? MyPageTableViewCell else {
      return .init()
    }
    
    return cell
  }
  
  private lazy var dataSource: RxTableViewSectionedReloadDataSource<StringArraySection> = .init(
    configureCell: { [weak self] _, _, indexPath, item in
      guard let cell = self?.tableViewCell(indexPath) else {
        return .init()
      }
      
      switch indexPath.section {
      case 0:
        // TODO: 연결된 소셜 로그인 타입을 서버에서 받아 파라미터로 넘길 예정
        cell.configure(socialType: .apple)
        return cell
        
      default:
        if indexPath.row == 2 {
          cell.configureVersion()
          return cell
        }
        
        cell.configure(title: item)
        return cell
      }
    }
  )
  
  // MARK: - Initializer
  init(reactor: MyPageReactor) {
    navigationBar = .init(title: "마이페이지", backgroundColor: .white)
    super.init()
    
    self.reactor = reactor
    bind()
    setupTableView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func viewDidLayoutSubviews() {
    setupLayoutConstraints()
  }
  
  // MARK: - Methods
  override func bind(reactor: MyPageReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  override func setupViews() {
    super.setupViews()
    
    view.addSubview(navigationBar)
    view.addSubview(tableView)
  }
}

// MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView: MyPageTableHeaderView = tableView.dequeueReusableHeaderFooterView()
    let sectionModel = dataSource[section]
    headerView.configure(sectionModel.header)
    
    if section != 0 {
      headerView.setDividerView()
    }
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0: return TableViewMetric.sectionAreaHeight
    default: return TableViewMetric.sectionWithDividerAreaHeight
    }
  }
}

// MARK: - Private Extenion
private extension MyPageViewController {
  
  // MARK: Properties
  var tableViewSelectionBinder: Binder<Int> {
    return .init(self) { owner, row in
      switch row {
      case 0:
        owner.coordinator?.pushWebView(.question)
      case 1:
        owner.coordinator?.pushWebView(.policy)
      case 3:
        owner.presentAlert(type: .logout, rightButtonAction: {
          owner.reactor?.action.onNext(.didTapLogoutButton)
        })
        owner.coordinator?.didFinish()
      case 4:
        owner.presentAlert(type: .deleteAccount, rightButtonAction: {
          owner.reactor?.action.onNext(.didTapDeleteAccountButton)
        })
        owner.coordinator?.didFinish()
      default:
        return
      }
    }
  }
  
  // MARK: Methods
  func bindAction(reactor: MyPageReactor) { }
  
  func bindState(reactor: MyPageReactor) {
    reactor.state
      .map { $0.isLoggedOut }
      .distinctUntilChanged()
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, isLoggedOut in
        // TODO: 로그아웃 또는 회원탈퇴한 경우 '연결된 계정'을 어떻게 보여줄지 문의 후 구현
      })
      .disposed(by: disposeBag)
  }
  
  func bind() {
    navigationBar.backButtonTapObservable
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.coordinator?.didFinish()
      })
      .disposed(by: disposeBag)
    
    tableView.rx.itemSelected
      .filter { $0.section == 1 }
      .map { $0.row }
      .bind(to: tableViewSelectionBinder)
      .disposed(by: disposeBag)
  }
  
  func setupLayoutConstraints() {
    navigationBar.pin.top().left().right()
    tableView.pin.top(to: navigationBar.edge.bottom).marginTop(16).horizontally().bottom(to: view.edge.bottom)
  }
  
  func setupTableView() {
    typealias Section = MyPageReactor.TableViewSections
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    let sections: Observable<[StringArraySection]> = .just([
      .init(header: Section.profile.headerTitle, items: Section.profile.itemsTitle),
      .init(header: Section.services.headerTitle, items: Section.services.itemsTitle)
    ])
    
    sections
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
