//
//  ConversionHistoryView.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/5/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class ConversionsHistoryView: UIView {

    
    // MARK: Properties
    var conversionHistory = [Conversion]()
    
    // MARK: Outlets
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var clearHistoryButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var tableViewStatusLabel: UILabel!
    
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        mainInit()
    }
    
    private func mainInit() {
        Bundle.main.loadNibNamed("ConversionHistoryView", owner: self, options: nil)
        addSubview(mainView)
        
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupUI()
    }
    
    func fetchHistory(){
        let conversionHistory = DBManager.readAll()
        if let conversionHistory = conversionHistory, conversionHistory.count > 0 {
            self.conversionHistory = [Conversion]()
            for exchange in conversionHistory {
                if let conversion = Conversion.parseObject(exchange) {
                    self.conversionHistory.append(conversion)
                }
            }
            enableHistoryUI()
            historyTableView.reloadData()
        } else {
            disableHistoryUI()
        }
    }
    
    // MARK: UI Helpers
    
    private func setupUI() {
        setupTableView()
    }
    
    private func enableHistoryUI() {
        tableViewStatusLabel.isHidden = true
        clearHistoryButton.isEnabled = true
        editButton.isEnabled = true
        clearHistoryButton.alpha = 1
        editButton.alpha = 1
    }
    
    private func disableHistoryUI() {
        tableViewStatusLabel.isHidden = false
        clearHistoryButton.isEnabled = false
        editButton.isEnabled = false
        clearHistoryButton.alpha = 0.5
        editButton.alpha = 0.5
    }
    
    private func setupTableView(){
        historyTableView.register(UINib(nibName: "ConversionHistoryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "historyCell")
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    
    // MARK: Actions
    
    @IBAction func editTableViewButton(_ sender: Any) {
        historyTableView.setEditing(!historyTableView.isEditing, animated: true)
        var buttonTitle = "Edit"
        buttonTitle = historyTableView.isEditing ? "Done" : "Edit"
        editButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func clearHistoryButton(_ sender: Any) {
        if conversionHistory.count > 0 {
            DBManager.deleteAll()
            conversionHistory.removeAll()
            historyTableView.reloadData()
            disableHistoryUI()
            editButton.setTitle("Edit", for: .normal)
        }
    }
}


// MARK: DataUpdate Stub

extension ConversionsHistoryView : DataUpdateDelegate {
    func updateHistory() {
        fetchHistory()
        conversionHistory.count > 0 ? enableHistoryUI() : disableHistoryUI()
    }
}


// MARK: Tableview Stubs

extension ConversionsHistoryView : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversionHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! ConversionHistoryTableViewCell
        cell.generateCell(conversionHistory[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            removeHistoryObject(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if conversionHistory.count <= 0 {
                disableHistoryUI()
            }
        default:
            break
        }
    }
    
    private func removeHistoryObject(index : Int){
        
        let historyObjectToDelete = conversionHistory[index]
        conversionHistory.remove(at: index)
        
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@ AND %K == %@ AND %K == %@ AND %K == %@", argumentArray: [
            "baseAmount" , historyObjectToDelete.baseCountedCurrency.amount!,
            "exchangeAmount" , historyObjectToDelete.exchangeCountedCurrency.amount!,
            "baseCurrencyCode" , historyObjectToDelete.baseCountedCurrency.currency.code!,
            "exchangeCurrencyCode" , historyObjectToDelete.exchangeCountedCurrency.currency.code!,
            "conversionDate" , historyObjectToDelete.date!
            ])
        
        DBManager.delete(predicate: predicate)
    }
}
