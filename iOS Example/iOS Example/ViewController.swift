//
//  ViewController.swift
//  iOS Example
//
//  Created by galaxy on 2023/2/2.
//

import UIKit
import SnapKit

fileprivate class Model {
    let title: String
    let vc: String
    
    public init(title: String, vc: String) {
        self.title = title
        self.vc = vc
    }
}

public final class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        tableView.contentInsetAdjustmentBehavior = .always
        return tableView
    }()
    
    private var dataSource: [Model] = []
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Demo"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        dataSource = [Model(title: "Water-Flow", vc: NSStringFromClass(WaterFlowListViewController.classForCoder())),
                      Model(title: "Row", vc: NSStringFromClass(RowViewController.classForCoder())),
                      Model(title: "Tag List(Equal height, not equal width)", vc: NSStringFromClass(TagListViewController.classForCoder())),
                      Model(title: "Irregular Tag List", vc: NSStringFromClass(IrregularTagListViewController.classForCoder())),
                      Model(title: "Mix List", vc: NSStringFromClass(MixListViewController.classForCoder())),
                      Model(title: "Decoration View", vc: NSStringFromClass(DecorationViewController.classForCoder())),
                      Model(title: "Auto-Size", vc: NSStringFromClass(AutoSizeViewController.classForCoder())),
                      Model(title: "Pinned Header Or Footer", vc: NSStringFromClass(PinnedHeaderOrFooterViewController.classForCoder())),]
        tableView.reloadData()
    }
}


extension ViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.classForCoder())) else { return UITableViewCell() }
        let model = dataSource[indexPath.row]
        if #available(iOS 14.0, *) {
            var config = UIListContentConfiguration.cell()
            config.text = model.title
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = model.title
        }
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.row]
        guard let vc = NSClassFromString(model.vc) as? UIViewController.Type else { return }
        let viewController = vc.init()
        viewController.navigationItem.title = model.title
        navigationController?.pushViewController(viewController, animated: true)
    }
}
