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
    class LabelValueFormatter: NSObject, IAxisValueFormatter {
        static var _spaceWidth: Double?
        
        class var spaceWidth: Double {
            if let spaceWidth = _spaceWidth {
                return spaceWidth
            }
            
            let spaceStr = " "
            let font = UIFont.avenirRegular(size: 9.0) ?? UIFont.systemFont(ofSize: 9.0)
            let attributes = [NSAttributedString.Key.font: font]
            
            let size = (spaceStr as NSString).size(withAttributes: attributes)
            
            let width = Double(size.width)
            _spaceWidth = width
            
            return width
        }
        
        let counts: [Int]
        let name: String
        
        init(counts: [Int], name: String) {
            self.counts = counts
            self.name = name
        }
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            let index = Int(value / StatView.Constants.spaceForBar)
            
            let string = "\(counts[index]) \(name.lowercased())"
            let font = axis?.labelFont ?? .systemFont(ofSize: 9.0)
            let attributes = [NSAttributedString.Key.font: font]
            
            let size = (string as NSString).size(withAttributes: attributes)
            let offset = max(60.0 - size.width, 0.0)
            
            let spaces = Int(Double(offset) / LabelValueFormatter.spaceWidth)
            
            return String(repeatElement(" ", count: spaces)) + string
        }
    }
    
    struct Constants {
        static let barWidth = 15.0
        static let spaceForBar = 20.0
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
        chart.drawBarShadowEnabled = false
        chart.drawValueAboveBarEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.pinchZoomEnabled = false
        chart.highlightPerTapEnabled = false
        chart.highlightFullBarEnabled = false
        chart.highlightPerDragEnabled = false
        chart.isUserInteractionEnabled = false
        
        chart.maxVisibleCount = 60
        
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        
        let font = UIFont.avenirRegular(size: 9.0) ?? UIFont.systemFont(ofSize: 9.0)
        
        let xAxis = chart.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.labelFont = font
        xAxis.labelCount = counts.count
        xAxis.valueFormatter = LabelValueFormatter(counts: counts, name: name)
        xAxis.enabled = true
        
        let legend = chart.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = false
        legend.form = .circle
        legend.formSize = 9
        legend.font = font
        legend.textColor = UIColor.Grayscale.dark
        legend.xEntrySpace = 4
        
        chart.fitBars = true
        
        let entries = counts.enumerated().map { elem in
            return BarChartDataEntry(x: Double(elem.offset) * Constants.spaceForBar, y: Double(elem.element))
        }
        
        let set = BarChartDataSet(values: entries, label: nil)
        set.drawValuesEnabled = true
        set.colors = UIColor.Poll.all
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
