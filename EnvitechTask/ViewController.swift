//
//  ViewController.swift
//  EnvitechTask
//
//  Created by yaniv shtein on 02/01/2022.
//

import UIKit
import Combine


class ViewController: UIViewController {
    
    
    var subscriptions:Set<AnyCancellable> = []
    var MainMenuButtons:[UIButton] = []
    var api:Api?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        GetData().getData().sink { completion in
            switch completion{
            case .failure(let err):
                print(err)
            case .finished:
                print("success")
            }
        } receiveValue: {[weak self] apiFromWeb in
            self?.api = apiFromWeb
            
            if let api = self?.api {
                for monitorType in 0..<api.MonitorType.count{
                    print(api.MonitorType[monitorType].Name)
                    self?.MainMenuButtons.append((self?.addButton(name: api.MonitorType[monitorType].Name, id:api.MonitorType[monitorType].Id))!)
                }
                self?.addHorizontalStackMainMenu(buttons: self!.MainMenuButtons)
            }

        }.store(in: &subscriptions)

                
        
    }

    func addButton(name:String, id:Int)->UIButton{
        let btn = UIButton(configuration: .plain())
        
        btn.setTitle(name, for: .normal)
        btn.titleLabel?.tintColor = .white
        btn.backgroundColor = .black
        btn.tag = id
        btn.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
       
        
        return btn
    }
    
    @objc func buttonClicked(button:UIButton){
        if let api = api {
            var menuItems:[UIAction] = []
            for monitors in api.Monitor{
                if button.tag == monitors.MonitorTypeId{
                    menuItems.append(UIAction(title: monitors.Name, handler: {[weak self] _ in
                        print("\(monitors.Name) clicked")
                        var labels:[UILabel] = []
                        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                        title.text = "AQI [level]"
                        labels.append(title)
                        for monitorType in api.MonitorType{
                            if monitors.MonitorTypeId == monitorType.Id{
                                for legends in api.Legends{
                                    if legends.Id == monitorType.LegendId{
                                        for tag in legends.tags{
                                            labels.append(self!.legendLabels(color: tag.Color, quality: tag.Label))
                                        }
                                    }
                                }
                            }
                        }
                        self?.addVerticalStackLegend(labels: labels)
                    }))
                }
            }
            let menu = UIMenu(title: "", options: .displayInline, children: menuItems)
            button.menu = menu
            button.showsMenuAsPrimaryAction = true
            
        }
     }
    
    func addHorizontalStackMainMenu(buttons:[UIButton]){
        let hstack = UIStackView()
        hstack.axis = .horizontal
        
        for button in buttons {
            hstack.addArrangedSubview(button)
        }
        
        view.addSubview(hstack)
        
        hstack.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            hstack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            hstack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hstack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func legendLabels(color:String, quality:String)->UILabel{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        label.text = "\(color)  \(quality)"
        
        return label
    }
    
    func addVerticalStackLegend(labels:[UILabel]){
        let vstack = UIStackView()
        vstack.axis = .vertical
        
        for label in labels {
            vstack.addArrangedSubview(label)
        }
        
        view.addSubview(vstack)
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            vstack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            vstack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    
}


