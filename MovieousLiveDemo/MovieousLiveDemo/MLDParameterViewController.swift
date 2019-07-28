//
//  MLDParameterViewController.swift
//  MovieousLiveDemo
//
//  Created by Chris Wang on 2019/4/17.
//  Copyright © 2019 Movieous Team. All rights reserved.
//

import UIKit

let DefaultTableViewContentMargin = 16

enum MLDParameterType {
    case boolean
    case float
    case int
    case enums
}

protocol CandidateValue {
    func string() -> String
}

struct MLDParameter {
    let name: String
    let type: MLDParameterType
    var value: Any
    var candidateValues: [CandidateValue]?
    
    init(name: String, type: MLDParameterType, value: Any, candidateValues: [CandidateValue]? = nil) {
        self.name = name
        self.type = type
        self.value = value
        self.candidateValues = candidateValues
    }
}

protocol MLDParameterTableViewCellDelegate: class {
    func parameterTableViewCell(_ tableViewCell: MLDParameterTableViewCell, parameterValueDidChanged parameter: MLDParameter)
}

class MLDParameterTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var delegate: MLDParameterTableViewCellDelegate?
    var parameter: MLDParameter! {
        didSet {
            textLabel?.text = parameter.name
            switch parameter.type {
            case .boolean:
                let switchView = UISwitch()
                switchView.isOn = parameter.value as! Bool
                switchView.addTarget(self, action: #selector(switchValueChanged(sender:)), for: .valueChanged)
                accessoryView = switchView
            case .float:
                let textField = UITextField()
                textField.text = "\(parameter.value)"
                textField.keyboardType = .decimalPad
                textField.adjustsFontSizeToFitWidth = true
                textField.textAlignment = .center
                textField.bounds = CGRect(x: 0, y: 0, width: contentView.frame.size.width / 2 - CGFloat(DefaultTableViewContentMargin), height: frame.size.height)
                accessoryView = textField
                NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChanged(sender:)), name: UITextField.textDidChangeNotification, object: textField)
            case .int:
                let textField = UITextField()
                textField.text = "\(parameter.value)"
                textField.keyboardType = .numberPad
                textField.adjustsFontSizeToFitWidth = true
                textField.textAlignment = .center
                textField.bounds = CGRect(x: 0, y: 0, width: contentView.frame.size.width / 2 - CGFloat(DefaultTableViewContentMargin), height: frame.size.height)
                accessoryView = textField
                NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChanged(sender:)), name: UITextField.textDidChangeNotification, object: textField)
            case .enums:
                let pickerView = UIPickerView()
                pickerView.dataSource = self
                pickerView.delegate = self
                pickerView.bounds = CGRect(x: 0, y: 0, width: contentView.frame.size.width / 2 - CGFloat(DefaultTableViewContentMargin), height: frame.size.height)
                for i in 0 ..< parameter!.candidateValues!.count {
                    let candidateValue = parameter!.candidateValues![i]
                    if (parameter.value as! CandidateValue).string() == candidateValue.string() {
                        pickerView.selectRow(i, inComponent: 0, animated: false)
                        break
                    }
                }
                accessoryView = pickerView
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func prepareForReuse() {
        accessoryView = nil
    }
    
    @objc func textFieldDidChanged(sender: Notification) {
        let textField = sender.object as! UITextField
        if textField.text?.count == 0 {
            textField.text = "0"
        }
        var parameter = self.parameter!
        switch parameter.type {
        case .float:
            parameter.value = (textField.text! as NSString).floatValue
        case .int:
            parameter.value = (textField.text! as NSString).intValue
        default:
            break
        }
        if let delegate = delegate {
            delegate.parameterTableViewCell(self, parameterValueDidChanged: parameter)
        }
    }
    
    @objc func switchValueChanged(sender: UISwitch) {
        var parameter = self.parameter!
        parameter.value = sender.isOn
        if let delegate = delegate {
            delegate.parameterTableViewCell(self, parameterValueDidChanged: parameter)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return parameter.candidateValues?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "\(parameter.candidateValues![row].string())"
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var parameter = self.parameter!
        parameter.value = parameter.candidateValues![row]
        if let delegate = delegate {
            delegate.parameterTableViewCell(self, parameterValueDidChanged: parameter)
        }
    }
}

protocol MLDParameterViewControllerDelegate: class {
    func parameterViewController(_ viewController: MLDParameterViewController, parametersDidSaved parameters: [MLDParameter])
}

class MLDParameterViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    weak var delegate: MLDParameterViewControllerDelegate?
    var tapGestureRecognizer: UITapGestureRecognizer!
    var parameters: [MLDParameter]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        self.tableView.register(MLDParameterTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed(sender:)))
        navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    @objc func saveButtonPressed(sender: UIButton) {
        if let delegate = delegate {
            delegate.parameterViewController(self, parametersDidSaved: parameters)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension MLDParameterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MLDParameterTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MLDParameterTableViewCell
        cell.parameter = parameters![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch parameters[indexPath.row].type {
        case .enums:
            return 100
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension MLDParameterViewController: MLDParameterTableViewCellDelegate {
    func parameterTableViewCell(_ tableViewCell: MLDParameterTableViewCell, parameterValueDidChanged parameter: MLDParameter) {
        parameters[tableView.indexPath(for: tableViewCell)!.row] = parameter
    }
}
