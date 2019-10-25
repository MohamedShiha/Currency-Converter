//
//  CurrencyConverterViewController.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/3/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class CurrencyConverterViewController: UIViewController {

    // MARK: Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//    let converterView = ConverterView()
//    let conversionsHistoryView = ConversionsHistoryView()
    
    var converterView : ConverterView!
    var conversionsHistoryView : ConversionsHistoryView!
    
    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    deinit {
        converterView = nil
        conversionsHistoryView = nil
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: Setup UI
    
    func setupViews() {
        
        converterView = ConverterView()
        conversionsHistoryView = ConversionsHistoryView()
        
        converterView.delegate = self
        converterView.updateDelegate = conversionsHistoryView.self
        conversionsHistoryView.fetchHistory()
        
        let converterViewXPos = self.view.frame.width * CGFloat(0)
        let conversionHistoryViewXPos = self.view.frame.width * CGFloat(1)
        
        converterView.frame = CGRect(x: converterViewXPos, y: 0, width: view.bounds.width, height: scrollView.bounds.height)
        conversionsHistoryView.frame = CGRect(x: conversionHistoryViewXPos, y: 0, width: view.bounds.width, height: scrollView.bounds.height)

        scrollView.addSubview(converterView)
        scrollView.addSubview(conversionsHistoryView)
        
        scrollView.contentSize.width = converterView.frame.width * CGFloat(2)
    }
}


// MARK: ConverterView Stubs

extension CurrencyConverterViewController : ConverterViewDelegate {
    
    func present(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}
