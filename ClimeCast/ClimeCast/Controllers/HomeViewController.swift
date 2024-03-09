//
//  HomeViewController.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//

import UIKit
import Combine

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var degreeCelsiusLabel: UILabel!
    @IBOutlet weak var degreeFarenheitLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var celciusView: UIView!
    @IBOutlet weak var farenheitView: UIView!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var moreView: UIView!
    
    var viewModel: WeatherViewModel
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        subscribeToPublishers()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = WeatherViewModel(client: WeatherClient())
        super.init(coder: coder)
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
        guard let text = txtField.text, !text.isEmpty else {
            showAlert(title: "", message: "Please Input your preferred city")
            return
        }
        
        viewModel.fetchWeather(q: text)
    }
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = board.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        nextVC.data = viewModel.weather.value
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        displayBottomData(ishidden: true)
    }
    
    func setupViews() {
        setupTextField()
        displayBottomData(ishidden: true)
        preloadData()
    }
    
    func setupTextField() {
        txtField.becomeFirstResponder()
        txtField.tintColor = .label
        txtField.delegate = self
        txtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func displayBottomData(ishidden: Bool) {
        celciusView.isHidden = ishidden
        farenheitView.isHidden = ishidden
        weatherView.isHidden = ishidden
        moreView.isHidden = ishidden
    }
    
    func preloadData() {
        if let savedWeather: WeatherData = PersistenceManager.main.loadCustomModel(forKey: "WeatherData") {
            viewModel.weather.send(savedWeather)
        }
    }
}

extension HomeViewController {
    private func subscribeToPublishers() {
        viewModel.weather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherData in
                guard let data = weatherData else { return }
                self?.txtField.text = data.name
                self?.degreeCelsiusLabel.text = data.main?.celsius
                self?.degreeFarenheitLabel.text = data.main?.fahrenheit
                self?.weatherLabel.text = data.weather.first?.description
                self?.displayBottomData(ishidden: false)
            }
            .store(in: &cancellable)
        
        viewModel.weatherIcon
            .receive(on: DispatchQueue.main)
            .sink { [weak self] icon in
                self?.weatherImageView.image = icon
            }
            .store(in: &cancellable)
        
        viewModel.clientOrServerError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showAlert(title: "🚨📢", message: message)
                self?.displayBottomData(ishidden: true)
            }
            .store(in: &cancellable)
        
        viewModel.noInternetError
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showAlert(title: "🚨📢", message: "No Internet Connection")
                self?.displayBottomData(ishidden: true)
            }
            .store(in: &cancellable)
        
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.searchBtn.showLoader()
                    self?.txtField.isEnabled = false
                    self?.searchBtn.isEnabled = false
                    self?.displayBottomData(ishidden: true)
                } else {
                    self?.searchBtn.hideLoader(title: "Search")
                    self?.txtField.isEnabled = true
                    self?.searchBtn.isEnabled = true
                    self?.displayBottomData(ishidden: false)
                }
            }
            .store(in: &cancellable)
    }
}
