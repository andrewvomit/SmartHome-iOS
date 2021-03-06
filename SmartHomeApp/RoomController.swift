//
//  RoomController.swift
//  SmartHomeApp
//
//  Created by Mr. KabachokPuk on 30/12/2017.
//  Copyright © 2017 Andrew Belkov. All rights reserved.
//

import UIKit

class RoomController: UITableViewController {

    @IBOutlet weak var mainLightSwitch: UISwitch!
    @IBOutlet weak var mainLightSlider: UISlider!
    
    @IBOutlet weak var currentValueLabel: UILabel!
    
    @IBOutlet weak var ledSwitch: UISwitch!
    @IBOutlet weak var ledRedSlider: UISlider!
    @IBOutlet weak var ledGreenSlider: UISlider!
    @IBOutlet weak var ledBlueSlider: UISlider!
    
    @IBOutlet weak var currentColorView: UIView!
    
    @IBOutlet weak var thermometerLabel: UILabel!
    @IBOutlet weak var lightSensorLabel: UILabel!
    
    var stubView = UIView(frame: CGRect.zero)
    var indicator = UIActivityIndicatorView(frame: CGRect.zero)
    
    let connectionService = ConnectionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        prepareStubView()
    }
    
    func prepareStubView() {
        
        // Добавляем заглушку загрузки
        
        guard let navigationView = self.navigationController?.view else {
            return
        }
        
        navigationView.addSubview(stubView)
        stubView.translatesAutoresizingMaskIntoConstraints = false
        stubView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        stubView.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: 0).isActive = true
        stubView.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 0).isActive = true
        stubView.topAnchor.constraint(equalTo: navigationView.topAnchor, constant: 0).isActive = true
        stubView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 0).isActive = true
        
        stubView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.centerXAnchor.constraint(equalTo: stubView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: stubView.centerYAnchor).isActive = true

        stubView.isHidden = true
    }
    
    func showStub() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.stubView.isHidden = false
        }) { (_) in
            self.indicator.startAnimating()
        }
    }
    
    func hideStub() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.stubView.isHidden = true
        }) { (_) in
            self.indicator.stopAnimating()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1) ? 4 : 2
    }
    
    // MARK: - Main Light
    
    @IBAction func mainLightSwitchChanged(_ sender: Any) {
        
        // Посылаем на arduino
        mainLightChanged()
    }
    
    
    @IBAction func mainLightSliderChanged(_ sender: Any) {
    
        // Показываем значение яркости
        let value = Int(mainLightSlider.value * 100)
        currentValueLabel.text = "\(value)%"
    }
    
    
    @IBAction func mainLightSliderDidChanged(_ sender: Any) {
        
        // Посылаем на arduino
        mainLightChanged()
    }
    
    func mainLightChanged() {
        
        // Рассчитываем значение яркости
        let bright = Int(mainLightSlider.value * 255)
        
        // Делаем запрос к arduino
        showStub()
        connectionService.updateMainLight(turnOn: mainLightSwitch.isOn, bright: bright, success: { (data) in
            self.hideStub()
            
            self.updateUI(data: data)
            
        }) { (_) in
            self.hideStub()
            
            // Если ошибка, то показываем уведомление
//            let alert = UIAlertController(title: "Ошибка", message: "Ошибка подключения к контроллеру умного дома", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.cancel, handler: { (_) in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - LED
    
    @IBAction func ledSwitchChanged(_ sender: Any) {
        
        // Посылаем на arduino
        ledChanged()
    }
    
    @IBAction func ledSliderChanged(_ sender: Any) {
        
        // Показываем текущий цвет
        let color = UIColor(displayP3Red: CGFloat(ledRedSlider.value),
                            green: CGFloat(ledGreenSlider.value),
                            blue: CGFloat(ledBlueSlider.value), alpha: 1)
        currentColorView.backgroundColor = color
    }
    
    @IBAction func ledSliderDidChanged(_ sender: Any) {
        
        // Посылаем на arduino
        ledChanged()
    }
    
    func ledChanged() {
        
        // Рассчитываем значение цветов
        let red = Int(ledRedSlider.value * 255)
        let green = Int(ledGreenSlider.value * 255)
        let blue = Int(ledBlueSlider.value * 255)
        
        // Делаем запрос к arduino
        showStub()
        connectionService.updateLED(turnOn: ledSwitch.isOn, red: red, green: green, blue: blue, success: { (data) in
            self.hideStub()
            
            self.updateUI(data: data)
            
        }) { (_) in
            self.hideStub()
            
//            // Если ошибка, то показываем уведомление
//            let alert = UIAlertController(title: "Ошибка", message: "Ошибка подключения к контроллеру умного дома", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.cancel, handler: { (_) in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Thermometer
    
    @IBAction func updateThermometer(_ sender: Any) {
        
        // Делаем запрос к arduino
        showStub()
        connectionService.updateTemperature(success: { (data) in
            self.hideStub()
            
            self.updateUI(data: data)
            
        }) { (error) in
            self.hideStub()
            
//            // Если ошибка, то показываем уведомление
//            let alert = UIAlertController(title: "Ошибка", message: "Ошибка подключения к контроллеру умного дома", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.cancel, handler: { (_) in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Light sensor
    
    @IBAction func updateLightSensor(_ sender: Any) {
        
        // Делаем запрос к arduino
        showStub()
        connectionService.updateLightSensor(success: { (data) in
            self.hideStub()

            self.updateUI(data: data)
            
        }) { (error) in
            self.hideStub()
            
//            // Если ошибка, то показываем уведомление
//            let alert = UIAlertController(title: "Ошибка", message: "Ошибка подключения к контроллеру умного дома", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.cancel, handler: { (_) in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK -
    
    func updateUI(data: [[String: Any]]) {
        
        for dict in data {
            
            let title = dict["title"] as! String
            
            switch title {
            case "mainLight":
                
//                let turnOn: Int = dict["turnOn"] as! Int
//                let bright: Int = dict["bright"] as! Int
//
//                self.mainLightSwitch.isOn = (turnOn != 0)
//                self.mainLightSlider.value = Float(bright / 100)
//
//                self.mainLightSliderChanged(self)
                
                break
                
            case "led":
                
//                let turnOn: Int = dict["turnOn"] as! Int
//                let red: Int = dict["red"] as! Int
//                let green: Int = dict["green"] as! Int
//                let blue: Int = dict["blue"] as! Int
//
//                self.ledSwitch.isOn = (turnOn != 0)
//                self.ledRedSlider.value = Float(red / 100)
//                self.ledGreenSlider.value = Float(green / 100)
//                self.ledBlueSlider.value = Float(blue / 100)
//
//                self.ledSliderChanged(self)
                
                break
                
            case "thermometr":
                
                let value = (dict["value"] as! NSNumber).floatValue
                self.thermometerLabel.text = "\(value)°C"
                
                break
                
            case "lightSensor":
                
                let value = (dict["value"] as! NSNumber).floatValue
                self.lightSensorLabel.text = "\(value)%"
                
                break
                
            default:
                break
            }
        }
    }
}
