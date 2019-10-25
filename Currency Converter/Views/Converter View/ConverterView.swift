//
//  ConverterView.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/4/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

protocol ConverterViewDelegate : AnyObject {
    func present(viewController: UIViewController)
}

protocol DataUpdateDelegate : AnyObject{
    func updateHistory()
}

class ConverterView: UIView {

    
    // MARK: Properties
    
    var currentCurrency : Currency!
    var addedCurrencies = [CountedCurrency]()
    weak var delegate : ConverterViewDelegate?
    weak var updateDelegate : DataUpdateDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addedCurrenciesTableView: UITableView!
    
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var amountTextField: PaddedTextField!
    
    
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
        Bundle.main.loadNibNamed("ConverterView", owner: self, options: nil)
        addSubview(mainView)
        
        mainView.frame = self.bounds
        mainView.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
        
        currentCurrency = UserConfiguration.loadBaseCurrency()
        addedCurrencies = UserConfiguration.loadExchangeCurrencies()!
        
        setupTapGesture()

        setupTextFieldPlaceholder()
        setupAmountTextField()
        setupTableView()
        setupCurrencyInfo()
        convertAllCurrencies(false)
    }
    
    
    // MARK: Setup UI
    
    private func setupTextFieldPlaceholder(){
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.darkGray
        ]
        self.amountTextField.attributedPlaceholder = NSAttributedString(string: "amount", attributes: attributes)
    }
    
    private func setupAmountTextField() {
        let userAmount = UserConfiguration.loadAmountInput()
        amountTextField.text = "\(userAmount != 0.0 ? userAmount : 1.0)"
    }
    
    private func setupTableView(){
        addedCurrenciesTableView.register(UINib(nibName: "AddedCurrencyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "addedCurrency")
        addedCurrenciesTableView.delegate = self
        addedCurrenciesTableView.dataSource = self
    }
    
    private func setupCurrencyInfo() {
        self.currencyImage.image = currentCurrency.image
        currencyCodeLabel.text = currentCurrency.code
    }
    
    fileprivate func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        amountTextField.endEditing(true)
        amountTextField.text = amountTextField.text == "" ? "1.0" : amountTextField.text
    }
    
    // MARK: Actions
    
    @IBAction func addCurrencyButton(_ sender: Any) {
        getAvailableCurrencies()
    }
    
    @IBAction func tableViewEditButton(_ sender: Any) {
        addedCurrenciesTableView.setEditing(!addedCurrenciesTableView.isEditing, animated: true)
        var buttonTitle = "Edit"
        buttonTitle = addedCurrenciesTableView.isEditing ? "Done" : "Edit"
        editButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func convertButton(_ sender: Any) {
        convertAllCurrencies(true)
        UserConfiguration.saveAmountInput(NSString(string: amountTextField.text!).doubleValue)
    }
}


// MARK: TableView Stubs

extension ConverterView : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addedCurrency", for: indexPath) as! AddedCurrencyTableViewCell
        cell.generateCell(addedCurrencies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row > 0 {
            return .delete
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteAddedCurrency(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
    private func deleteAddedCurrency(index : Int) {
        addedCurrencies.remove(at: index)
        UserConfiguration.saveExchangeCurrencies(addedCurrencies)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tempCurrency = currentCurrency
        updateCurrencyUI(addedCurrencies[indexPath.row].currency)
        currentCurrency = addedCurrencies[indexPath.row].currency
        addedCurrencies[indexPath.row].currency = tempCurrency
        convertAllCurrencies(false)
        UserConfiguration.saveBaseCurrency(currentCurrency)
        UserConfiguration.saveExchangeCurrencies(addedCurrencies)
        addedCurrenciesTableView.reloadData()
    }
    
    private func updateCurrencyUI(_ currency : Currency) {
        
        amountTextField.text = "\(1.0)"
        currencyImage.image = currency.image
        currencyCodeLabel.text = currency.code
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        rearrangeAddedCurrencies(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        addedCurrenciesTableView.reloadData()
    }
    
    private func rearrangeAddedCurrencies(fromIndex : Int, toIndex : Int) {
        let source = addedCurrencies[fromIndex]
        let destination = addedCurrencies[toIndex]
        addedCurrencies[fromIndex] = destination
        addedCurrencies[toIndex] = source
        UserConfiguration.saveExchangeCurrencies(addedCurrencies)
    }
}


// MARK: Available Currencies Delegate

extension ConverterView : AvailableCurrenciesDelegate {
    
    func didAdd(_ currencyCode: String, _ currencyName: String) {
        if !addedCurrencies.contains(where: { $0.currency.code == currencyCode }) {
            let currency = Currency(image: Currency.getCurrencyImage(fromCode: currencyCode)!, name: currencyName, code: currencyCode)
            addedCurrencies.append(CountedCurrency(currency: currency, amount: 1))
            UserConfiguration.saveExchangeCurrencies(addedCurrencies)
            convertAllCurrencies(false)
        }
    }
}


// MARK: Functionality

extension ConverterView {
    
    private func getAvailableCurrencies() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let availableCurrenciesVC = storyBoard.instantiateViewController(withIdentifier: "AvailableCurrencies") as! AvailableCurrenciesViewController
        
        if availableCurrenciesVC.availableCurrencies == nil {
            CurrencyConverterClient.instance.getAvailableCurrencies { (availableCurrencies, error) in
                guard error == nil else {
                    self.displayError("Fetching Error", "Error occureded while fetching available currencies", "Try Again", {
                        self.getAvailableCurrencies()
                    })
                    return
                }
                availableCurrenciesVC.availableCurrencies = availableCurrencies?.sorted(by: { $0.0 < $1.0 })
                availableCurrenciesVC.delegate = self
                self.delegate?.present(viewController: availableCurrenciesVC)
            }
        }
    }
    
    private func convertAllCurrencies(_ shouldCreateDBRecord : Bool) {
        
        NetworkMonitor.shared.checkReachable { (reachable) in
            if reachable {
                var i = 0
                for countedCurrency in addedCurrencies {
                    
                    let amount = NSString(string: amountTextField!.text!).doubleValue == 0.0 ? 1.0 : NSString(string: amountTextField!.text!).doubleValue
                    
                    convertCurrencies(currentCurrency.code, countedCurrency.currency.code, amount, shouldCreateDBRecord, i)
                    i += 1
                }
            } else {
                displayError("Connection Error", "The app was unable to contact the server", "Ok", {})
            }
        }
    }
    
    private func convertCurrencies(_ baseCurrencyCode : String, _ exchangeCurrencyCode: String, _ amount : Double,_ shouldCreateDBRecord : Bool, _ forAddedCurrencyIndex : Int) {
        
        CurrencyConverterClient.instance.convertCurrency(from: baseCurrencyCode, to: exchangeCurrencyCode, amount: amount) { (rates, error) in
            guard error == nil else {
                self.displayError("Conversion Error", "Error occureded while converting currencies", "Try Again", {
                    self.convertCurrencies(baseCurrencyCode, exchangeCurrencyCode, amount, shouldCreateDBRecord, forAddedCurrencyIndex)
                })
                return
            }
            
            if let rates = rates {
                
                let currencyCode = Array(rates.keys)[0]
                let currency = rates[currencyCode]!
                
                if let rateForAmount = Double(currency[CurrencyConverterClient.JsonResponseKeys.rateForAmount]!) {
                    self.updateAddedCurrencies(currencyCode, rateForAmount)
                    
                    if shouldCreateDBRecord {
                        let conversion = Conversion(baseCountedCurrency: CountedCurrency(currency: self.currentCurrency, amount: NSString(string: self.amountTextField.text!).doubleValue), exchangeCountedCurrency: self.addedCurrencies[forAddedCurrencyIndex], date: Date())
                        self.createHistoryRecord(conversion)
                        self.updateDelegate?.updateHistory()
                    }
                }
            } else {
                self.displayError("Conversion Error", "Error occureded while converting currencies", "Try Again", { })
            }
        }
    }
    
    private func updateAddedCurrencies(_ code : String, _ amount : Double){
        
        let index = self.addedCurrencies.firstIndex(where: { $0.currency.code == code })
        if let index = index {
            addedCurrencies[index].amount = round(amount * 100) / 100
        }
        DispatchQueue.main.async {
            self.addedCurrenciesTableView.reloadData()
        }
    }
    
    
    // MARK: Helpers
    
    private func createHistoryRecord(_ conversion : Conversion) {
        DBManager.create(conversion)
    }
    
    private func displayError (_ alertTitle: String, _ alertMessage: String, _ actionTitle: String, _ completion : @escaping() -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (alert) in
                completion()
            }))
            self.delegate?.present(viewController: alert)
        }
    }
}
