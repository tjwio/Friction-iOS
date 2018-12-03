//
//  MainViewController.swift
//  friction
//
//  Created by Tim Wong on 11/18/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import SnapKit

class MainViewController: UIViewController, PollSelectionDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private struct Constants {
        static let liveCellIdentifier = "LivePollCellIdentifier"
        static let historyCellIdentifier = "HistoryPollCellIdentifier"
    }
    
    let avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.blankAvatarBlack, for: .normal)
        button.layer.cornerRadius = 15.0
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var disposables = CompositeDisposable()
    
    deinit {
        disposables.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Today's Clash"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor    :    UIColor.black,
            .font               :    UIFont.avenirBold(size: 30.0) ?? UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor    :    UIColor.black,
            .font               :    UIFont.avenirBold(size: 18.0) ?? UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
        
        let avatarBarButtonItem = UIBarButtonItem(customView: avatarButton)
        navigationItem.rightBarButtonItem = avatarBarButtonItem
        
        avatarButton.addTarget(self, action: #selector(self.showProfileViewController(_:)), for: .touchUpInside)
        
        activityIndicator.startAnimating()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlRefreshed(_:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        setupConstraints()
        
        disposables += Signal.combineLatest(UserHolder.shared.loadUser(success: nil, failure: nil), PollHolder.shared.initialLoad(success: nil, failure: nil)).observe { [weak self] event in
            switch event {
            case .completed:
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                self?.loadUserImage()
            case .failed(_):
                DispatchQueue.main.async {
                    AppManager.shared.logOut()
                }
            default: break
            }
        }
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        avatarButton.snp.makeConstraints { make in
            make.height.width.equalTo(30.0)
        }
    }
    
    // MARK: reload
    
    private func reloadHelper(completion: EmptyHandler?) {
        disposables += PollHolder.shared.initialLoad(success: nil, failure: nil).observe { _ in
            completion?()
        }
    }
    
    @objc private func refreshControlRefreshed(_ sender: UIRefreshControl) {
        reloadHelper {
            sender.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // MARK: load image
    
    private func loadUserImage() {
        UserHolder.shared.user.loadImage(success: { image in
            self.avatarButton.setImage(image, for: .normal)
        }, failure: nil)
    }
    
    // MARK: selection
    
    func didSelect(item: (value: String, percent: Double, selected: Bool), itemIndex: Int, cellIndex: Int) {
        let poll = PollHolder.shared.polls[cellIndex]
        let option = poll.options[itemIndex]
        
        poll.vote(option: option, success: { _ in
            self.tableView.reloadSections(IndexSet(integer: cellIndex), with: .automatic)
        }) { _ in
            self.tableView.reloadSections(IndexSet(integer: cellIndex), with: .automatic)
        }
    }
    
    // MARK: profile
    
    @objc private func showProfileViewController(_ sender: Any?) {
        let viewController = ProfileViewController(user: UserHolder.shared.user)
        viewController.successCallback = { [weak self] in
            DispatchQueue.main.async {
                self?.showLeftMessage("Successfully updated profile", type: .success)
                self?.avatarButton.setImage(UserHolder.shared.user.image.value, for: .normal)
            }
        }
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        
        self.present(viewController, animated: false, completion: nil)
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PollHolder.shared.polls.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 190.0 : 135.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BasePollTableViewCell
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.liveCellIdentifier) as? LivePollTableViewCell ?? LivePollTableViewCell(style: .default, reuseIdentifier: Constants.liveCellIdentifier)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.historyCellIdentifier) as? HistoryPollTableViewCell ?? HistoryPollTableViewCell(style: .default, reuseIdentifier: Constants.historyCellIdentifier)
        }
        
        let poll = PollHolder.shared.polls[indexPath.section]
        let totalVotes = poll.totalVotes
        
        cell.nameLabel.text = poll.name
        cell.dateLabel.text = DateFormatter.dayFullMonth.string(from: poll.date).appending(" at ").appending(DateFormatter.amPm.string(from: poll.date))
        cell.voteLabel.text = "\(totalVotes) Votes"
        cell.items = poll.items
        cell.progressHolderView.isHidden = totalVotes == 0
        
        cell.layer.cornerRadius = 4.0
        cell.layer.borderColor = UIColor.Grayscale.lighter.cgColor
        cell.layer.borderWidth = 1.0
        
        cell.index = indexPath.section
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = ChatViewController(poll: PollHolder.shared.polls[indexPath.section])
        navigationController?.pushViewController(viewController, animated: true)
    }
}
