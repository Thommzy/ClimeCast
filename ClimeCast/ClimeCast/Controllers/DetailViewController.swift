//
//  DetailViewController.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var degreeCelsiusLabel: UILabel!
    @IBOutlet weak var degreeFarenheitLabel: UILabel!
    
    var data: WeatherData?
    var favImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightBarButtonItem()
        setupView()
    }
    
    private func setupView() {
        cityLabel.text = data?.name
        countryLabel.text = data?.sys?.country
        degreeCelsiusLabel.text = data?.main?.celsius
        degreeFarenheitLabel.text = data?.main?.fahrenheit
    }
    
    func setupRightBarButtonItem() {
        favImage = PersistenceManager.main.isFaved ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        let button = UIButton(type: .custom)
        button.setImage(favImage, for: .normal)
        button.addTarget(self, action: #selector(rightBarButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        
        let rightBarButtonItem = UIBarButtonItem(customView: button)
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func rightBarButtonTapped() {
        PersistenceManager.main.isFaved.toggle()
        
        DispatchQueue.main.async {
            self.setupRightBarButtonItem()
        }
        generateHapticFeedback()
    }
    
    func generateHapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
}
