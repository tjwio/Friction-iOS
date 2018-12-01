//
//  MainViewController.swift
//  friction
//
//  Created by Tim Wong on 11/18/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController, PollSelectionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private struct Constants {
        static let historyCellIdentifier = "HistoryPollCellIdentifier"
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
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
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor    :    UIColor.black,
            .font               :    UIFont.avenirBold(size: 18.0) ?? UIFont.preferredFont(forTextStyle: .largeTitle)
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
        PollHolder.shared.initialLoad(success: { polls in
            completion?()
        }) { _ in
            completion?()
        }
    }
    
    // MARK: selection
    
    func didSelect(item: (value: String, count: Int, selected: Bool), itemIndex: Int, cellIndex: Int) {
        let poll = PollHolder.shared.polls[cellIndex]
        let option = poll.options[itemIndex]
        
        poll.vote(option: option, success: { _ in
            self.tableView.reloadSections(IndexSet(integer: cellIndex), with: .automatic)
        }) { _ in
            self.tableView.reloadSections(IndexSet(integer: cellIndex), with: .automatic)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.historyCellIdentifier) as? HistoryPollTableViewCell ?? HistoryPollTableViewCell(style: .default, reuseIdentifier: Constants.historyCellIdentifier)
        
        let poll = PollHolder.shared.polls[indexPath.section]
        let totalVotes = poll.totalVotes
        
        cell.nameLabel.text = poll.name
        cell.dateLabel.text = DateFormatter.dayFullMonth.string(from: poll.date).appending(" at ").appending(DateFormatter.amPm.string(from: poll.date))
        cell.voteLabel.text = "\(totalVotes) Votes"
        cell.items = poll.options.map { return (value: $0.name, count: $0.votes == 0 ? 0 : Int(Double($0.votes / totalVotes) * 100.0), selected: $0.vote != nil) }
        
        cell.layer.cornerRadius = 4.0
        cell.layer.borderColor = UIColor.Grayscale.lighter.cgColor
        cell.layer.borderWidth = 1.0
        
        cell.index = indexPath.section
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
