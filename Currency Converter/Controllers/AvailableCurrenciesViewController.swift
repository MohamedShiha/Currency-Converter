//
//  AvailableCurrenciesViewController.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/6/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

protocol AvailableCurrenciesDelegate : AnyObject {
    func didAdd(_ currencyCode : String, _ currencyName : String)
}

class AvailableCurrenciesViewController: UIViewController {

    
    // MARK: Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var availableCurrencies : [(key: String, value: String)]!
    var filteredCurrencies = [(key: String, value: String)]()
    weak var delegate : AvailableCurrenciesDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Outlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var availableCurrenciesTableView: UITableView!
    
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        filteredCurrencies = availableCurrencies
        availableCurrenciesTableView.backgroundView?.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
    }
    
    private func setupSearchController () {
        searchController.searchBar.placeholder = "Enter country or currency name"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .black
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.returnKeyType = .search
        
        searchController.isActive = true
        availableCurrenciesTableView.tableHeaderView = searchController.searchBar
    }

    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: TableView Stubs

extension AvailableCurrenciesViewController : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
        
        cell.textLabel?.text =  filteredCurrencies[indexPath.row].key
        cell.detailTextLabel?.text = filteredCurrencies[indexPath.row].value
        
//        let bgView = UIView()
//        bgView.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.0862745098, blue: 0.1333333333, alpha: 1)
//        cell.selectedBackgroundView = bgView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        delegate?.didAdd(filteredCurrencies[indexPath.row].key, filteredCurrencies[indexPath.row].value)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchController.searchBar.bounds.height / 10
    }
}


// MARK: SearchResultsUpdater Stubs

extension AvailableCurrenciesViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText (_ searchText : String) {
        if searchText.count > 0 {
            filteredCurrencies = availableCurrencies.filter({ (currency) -> Bool in
                
                return currency.key.lowercased().contains(searchText.lowercased()) || currency.value.lowercased().contains(searchText.lowercased())
            })
            availableCurrenciesTableView.reloadData()
        }
    }
}


// MARK: SearchBar Stubs

extension AvailableCurrenciesViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredCurrencies = availableCurrencies
        availableCurrenciesTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        filteredCurrencies = availableCurrencies
        availableCurrenciesTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            filteredCurrencies = availableCurrencies
        }
    }
}
