//
//  MainViewController.swift
//  friction
//
//  Created by Tim Wong on 11/18/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private struct Constants {
        static let historyCellIdentifier = "HistoryPollCellIdentifier"
    }
    
    var polls = [Poll]()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 24.0, left: 0.0, bottom: 12.0, right: 0.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Today's Clash"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor    :    UIColor.black,
            .font               :    UIFont.avenirBold(size: 30.0) ?? UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
        
        activityIndicator.startAnimating()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        setupConstraints()
        
        reloadHelper { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
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
    }
    
    // MARK: reload
    
    private func reloadHelper(completion: EmptyHandler?) {
        NetworkHandler.shared.getPolls(success: { polls in
            self.polls = polls
            completion?()
        }) { _ in
            completion?()
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return polls.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 190.0 : 135.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.historyCellIdentifier) as? HistoryPollTableViewCell ?? HistoryPollTableViewCell(style: .default, reuseIdentifier: Constants.historyCellIdentifier)
        
        let poll = polls[indexPath.section]
        cell.nameLabel.text = poll.name
        cell.dateLabel.text = DateFormatter.dayFullMonth.string(from: poll.date)
        cell.voteLabel.text = "\(poll.totalVotes) Votes"
        
        return cell
    }
}
