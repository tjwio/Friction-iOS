//
//  StatView.swift
//  friction
//
//  Created by Tim Wong on 12/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class StatView: UIView {
    private struct Constants {
        static let barWidth = 12.0
        static let spaceForBar = 13.0
    }
    
    var counts: [Int]
    var name: String
    
    let chart: HorizontalBarChartView = {
        let chart = HorizontalBarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        return chart
    }()
    
    init(counts: [Int], name: String) {
        self.counts = counts
        self.name = name
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let entries = counts.enumerated().map { elem in
            return BarChartDataEntry(x: Double(elem.offset) * Constants.spaceForBar, y: Double(elem.element))
        }
        
        let set = BarChartDataSet(values: entries, label: nil)
        let data = BarChartData(dataSet: set)
        data.setValueFont(.avenirMedium(size: 10.0) ?? .systemFont(ofSize: 10.0))
        data.barWidth = Constants.barWidth
        
        chart.data = data
        
        addSubview(chart)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        chart.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
