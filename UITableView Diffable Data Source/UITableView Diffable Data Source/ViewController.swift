//
//  ViewController.swift
//  UITableView Diffable Data Source
//
//  Created by Akshay Kumar on 15/01/24.
//

import UIKit

enum Section {
    case main
}

struct Fruit: Hashable {
    let identifier = UUID()
    let title: String
}

final class ViewController: UIViewController, UITableViewDelegate {
    
    private let fruitTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    private var fruits: [Fruit] = []
    private var dataSource: UITableViewDiffableDataSource<Section, Fruit>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Fruits"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(plusBarButtonAction))
        fruitTable.delegate = self
        view.addSubview(fruitTable)
        fruitTable.frame = view.bounds
        
        dataSource = UITableViewDiffableDataSource(tableView: fruitTable) { tableView, indexPath, fruit -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = fruit.title
            return cell
        }
    }
    
    @objc
    private func plusBarButtonAction() {
        let alert = UIAlertController(title: "Add fruit", message: "", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let text = alert.textFields?.first?.text,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
            }
            let fruit = Fruit(title: text)
            self.fruits.append(fruit)
            self.updateSnapshot()
        }))
        present(alert, animated: true)
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Fruit>()
        snapshot.appendSections([.main])
        snapshot.appendItems(fruits)
        dismiss(animated: true) {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
