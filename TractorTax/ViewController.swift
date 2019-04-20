//
//  ViewController.swift
//  TractorTax
//
//  Created by Robi Harid on 14/04/2019.
//  Copyright © 2019 Robi Harid. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    let font = "Montserrat Semibold"
    let fontSize = 20
    let currencyFormatter = NumberFormatter()
    
    var incomeValue = 500.00
    var minIncome = 0.00
    let maxIncome = 2_000_000.00
    
    var expenseValue = 50.00
    let minExpense = 0.00
    var maxExpense = 2_000_000.00
    
    var pensionValue = 200.00
    let minPension = 00.00
    var maxPension = 40_000.00
    var maxPensionMonth = 0.00
    
    var mileageValue = 5.00
    let minMileage = 0.00
    var maxMileage = 2_000_000.00
    
    var incomeValueYear = 115_000.00
    var expenseValueYear = 0.00
    var mileageValueYear = 0.00
    var pensionValueYear = 0.00
    var totalExpenseValueYear = 0.00
    
    var preTaxProfitYear = 0.00
    var postTaxProfitYear = 0.00
    var corporationTaxYear = 0.00
    var dividendsValueYear = 0.00
    var dividendsTaxYear = 0.00
    
    var dividendsTaxableIncomeYear = 0.00
    var personalAllowanceYear = 12_500.00
    var dividendAllowanceYear = 2_500.00
    var officeAllowanceYear = 208.00
    var totalAllowanceYear = 0.00
    
    var basicDividendsRate = 0.075
    var higherDividendsRate = 0.325
    var additionalDividendsRate = 0.381
    var corporationTaxRate = 0.19
    
    var maximumSalaryBeforeNI = 8_632.00
    var basicTaxBracket = 50_000.00
    var higherTaxBracket = 150_000.00
    
    var maxBasicDividendsTax = 2_662.50
    var maxHigherDividendsTax = 32_500.00
    
    var monthlyIncomeValue = 0.00
    var yearlyIncomeValue = 0.00
    
    @IBOutlet weak var incomeDayYear: UISegmentedControl!
    @IBOutlet weak var expenseDayYear: UISegmentedControl!
    @IBOutlet weak var pensionMonthYear: UISegmentedControl!
    @IBOutlet weak var mileageDayYear: UISegmentedControl!
    
    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var pensionTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    
    @IBOutlet weak var incomeStepper: UIStepper!
    @IBOutlet weak var expenseStepper: UIStepper!
    @IBOutlet weak var pensionStepper: UIStepper!
    @IBOutlet weak var mileageStepper: UIStepper!
    
    @IBOutlet weak var monthlyIncomeLabel: UILabel!
    @IBOutlet weak var yearlyIncomeLabel: UILabel!
    
    @IBAction func incomeDayYearChanged(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            incomeValue = calculateDay(yearRate: incomeValue)
            changeTextField(textField: incomeTextField, stepper: incomeStepper, value: incomeValue)
        } else
        {
            incomeValue = calculateYear(dayRate: incomeValue)
            changeTextField(textField: incomeTextField, stepper: incomeStepper, value: incomeValue)
        }
        updateIncomeLabels()
    }
    @IBAction func incomeTextFieldChanged(_ sender: UITextField)
    {
        if checkValidInput(textField: incomeTextField, min: minIncome, max: maxIncome)
        {
            incomeValue = Double(incomeTextField.text!) ?? 50.00
        }
        changeTextField(textField: incomeTextField, stepper: incomeStepper, value: incomeValue)
        updateIncomeLabels()
    }
    @IBAction func incomeStepperChanged(_ sender: UIStepper)
    {
        incomeValue = sender.value
        changeTextField(textField: incomeTextField, stepper: incomeStepper, value: incomeValue)
        updateIncomeLabels()
    }
    @IBAction func expenseDayYearChanged(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0 {
            expenseValue = calculateDay(yearRate: expenseValue)
            changeTextField(textField: expenseTextField, stepper: expenseStepper, value: expenseValue)
        } else {
            expenseValue = calculateYear(dayRate: expenseValue)
            changeTextField(textField: expenseTextField, stepper: expenseStepper, value: expenseValue)
        }
        updateIncomeLabels()
    }
    @IBAction func expenseTextFieldChanged(_ sender: UITextField)
    {
        // modify expenses to user input if they are within a valid range
        
        // if expense field is set to day then check if it is within limit
        if expenseDayYear.selectedSegmentIndex == 0 {
            if checkValidInput(textField: expenseTextField, min: minExpense, max: maxExpense) {
                expenseValue = Double(expenseTextField.text!) ?? 0.00
            }
        // otherwise, expense field is set to year
        } else {
            if checkValidInput(textField: expenseTextField, min: minExpense, max: maxExpense) {
                expenseValue = Double(expenseTextField.text!) ?? 0.00
            }
        }
        // make the change to the text field
        changeTextField(textField: expenseTextField, stepper: expenseStepper, value: expenseValue)
        updateIncomeLabels()
    }
    @IBAction func expenseStepperChanged(_ sender: UIStepper)
    {
        
        if expenseDayYear.selectedSegmentIndex == 0 {
            if checkValidRange(min: minExpense, max: maxExpense, value: sender.value) {
                expenseValue = sender.value
            }
        } else {
            if checkValidRange(min: minExpense, max: maxExpense, value: sender.value) {
                expenseValue = sender.value
            }
        }
        changeTextField(textField: expenseTextField, stepper: expenseStepper, value: expenseValue)
        updateIncomeLabels()
    }
    @IBAction func pensionMonthYearChanged(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0 {
            pensionValue = calculateMonth(yearRate: pensionValue)
            changeTextField(textField: pensionTextField, stepper: pensionStepper, value: pensionValue)
        } else {
            pensionValue = calculateYearFromMonth(monthRate: pensionValue)
            changeTextField(textField: pensionTextField, stepper: pensionStepper, value: pensionValue)
        }
        updateIncomeLabels()
    }
    @IBAction func pensionTextFieldChanged(_ sender: UITextField)
    {
        // if expense field is set to day then check if it is within limit
        if pensionMonthYear.selectedSegmentIndex == 0 {
            if checkValidInput(textField: pensionTextField, min: minPension, max: maxPensionMonth) {
                pensionValue = Double(pensionTextField.text!) ?? 0.00
            }
            // otherwise, expense field is set to year
        } else {
            if checkValidInput(textField: pensionTextField, min: minPension, max: maxPension) {
                pensionValue = Double(pensionTextField.text!) ?? 0.00
            }
        }
        changeTextField(textField: pensionTextField, stepper: pensionStepper, value: pensionValue)
        updateIncomeLabels()
    }
    @IBAction func pensionStepperChanged(_ sender: UIStepper)
    {
        pensionValue = sender.value
        changeTextField(textField: pensionTextField, stepper: pensionStepper, value: pensionValue)
        updateIncomeLabels()
    }
    @IBAction func mileageDayYearChanged(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0 {
            mileageValue = calculateDay(yearRate: mileageValue)
            changeTextField(textField: mileageTextField, stepper: mileageStepper, value: mileageValue)
        } else {
            mileageValue = calculateYear(dayRate: mileageValue)
            changeTextField(textField: mileageTextField, stepper: mileageStepper, value: mileageValue)
        }
        updateIncomeLabels()
    }
    @IBAction func mileageTextFieldChanged(_ sender: UITextField)
    {
        // modify expenses to user input if they are within a valid range
        
        // if expense field is set to day then check if it is within limit
        if mileageDayYear.selectedSegmentIndex == 0 {
            if checkValidInput(textField: mileageTextField, min: minMileage, max: maxMileage) {
                mileageValue = Double(mileageTextField.text!) ?? 0.00
            }
            // otherwise, expense field is set to year
        } else {
            if checkValidInput(textField: mileageTextField, min: minMileage, max: maxMileage) {
                mileageValue = Double(mileageTextField.text!) ?? 0.00
            }
        }
        // make the change to the text field
        changeTextField(textField: mileageTextField, stepper: mileageStepper, value: mileageValue)
        updateIncomeLabels()
    }
    @IBAction func mileageStepperChanged(_ sender: UIStepper)
    {
        mileageValue = sender.value
        changeTextField(textField: mileageTextField, stepper: mileageStepper, value: mileageValue)
        updateIncomeLabels()
    }
    func updateMaximumValues()
    {
        // calculate max expenses for yearly, daily and monthly values approriately if income is reduced and values are greater than income, reset them to income value
        maxPension = min(incomeValueYear, 40_000.00)
        maxPensionMonth = calculateMonth(yearRate: maxPension)
        pensionStepper.maximumValue = maxPension
        // for steppers that are selected to month or day rates, set max appropriately
        if pensionMonthYear.selectedSegmentIndex == 0
        {
            pensionStepper.maximumValue = maxPensionMonth
        }
        if pensionValueYear > maxPension {
            pensionValue = resetValues(segment: pensionMonthYear, stepper: pensionStepper, value: pensionValue)
            changeTextField(textField: pensionTextField, stepper: pensionStepper, value: pensionValue)
        }
        
    }
    func resetValues(segment: UISegmentedControl, stepper: UIStepper, value: Double) -> Double
    {
        let title = segment.titleForSegment(at: segment.selectedSegmentIndex)
        switch title
        {
        case "Day":
            return calculateDay(yearRate: incomeValueYear)
        case "Year":
            return incomeValueYear
        case "Month":
            return calculateMonth(yearRate: incomeValueYear)
        default:
            return 0.00
        }
    }
    func updateIncomeLabels()
    {
        incomeValueYear = calculateYearFromSegment(income: incomeValue, segment: incomeDayYear)
        expenseValueYear = calculateYearFromSegment(income: expenseValue, segment: expenseDayYear)
        pensionValueYear = calculateYearFromSegment(income: pensionValue, segment: pensionMonthYear)
        mileageValueYear = calculateYearFromSegment(income: mileageValue, segment: mileageDayYear)
        // calculate monthly income
        maximumSalaryBeforeNI = min(8_632.00, incomeValueYear)
        // total expenses
        totalExpenseValueYear = expenseValueYear + mileageValueYear + maximumSalaryBeforeNI + pensionValueYear
        if (incomeValueYear > totalExpenseValueYear)
        {
            // business has made a profit, calculate gains and tax
            preTaxProfitYear = incomeValueYear - totalExpenseValueYear
            corporationTaxYear = preTaxProfitYear * corporationTaxRate
            postTaxProfitYear = preTaxProfitYear - corporationTaxYear
            dividendsValueYear = postTaxProfitYear
            calculateDividendsTax()
            dividendsValueYear = dividendsValueYear - dividendsTaxYear
            //        print("Pre tax profit: \(preTaxProfitYear)")
            //        print("Corporation tax: \(corporationTaxYear)")
            //        print("Post tax profit: \(postTaxProfitYear)")
            //        print("Dividends value : \(dividendsValueYear)")
            //        print("Dividends tax : \(dividendsTaxYear)")
            //        print("Expense value : \(expenseValueYear)")
            yearlyIncomeValue = dividendsValueYear + totalExpenseValueYear + officeAllowanceYear
            monthlyIncomeValue = yearlyIncomeValue/12
            
            let monthlyString = calculateCurrencyString(value: monthlyIncomeValue)
            let yearlyString = calculateCurrencyString(value: yearlyIncomeValue)
            // set income labels and their colours
            monthlyIncomeLabel.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.19, alpha: 1.0)
            yearlyIncomeLabel.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.19, alpha: 1.0)
            monthlyIncomeLabel.text = "Monthly Income: \(monthlyString)"
            yearlyIncomeLabel.text = "Yearly Income: \(yearlyString)"
        } else if incomeValueYear >= (totalExpenseValueYear - maximumSalaryBeforeNI) {
            // if your only income is your salary, it is technically marked as a loss on the business accounts but for the purpose of the calculator we will assume it is a personal gain
            yearlyIncomeValue = incomeValueYear - (expenseValueYear + pensionValueYear + mileageValueYear)
            monthlyIncomeValue = yearlyIncomeValue/12
            
            let monthlyString = calculateCurrencyString(value: monthlyIncomeValue)
            let yearlyString = calculateCurrencyString(value: yearlyIncomeValue)
            // set income labels and their colours
            monthlyIncomeLabel.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.19, alpha: 1.0)
            yearlyIncomeLabel.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.19, alpha: 1.0)
            monthlyIncomeLabel.text = "Monthly Income: \(monthlyString)"
            yearlyIncomeLabel.text = "Yearly Income: \(yearlyString)"
        } else {
            // business has made a loss, return expenses minus income
            
            yearlyIncomeValue = incomeValueYear - totalExpenseValueYear
            monthlyIncomeValue = yearlyIncomeValue/12
            
            let monthlyString = calculateCurrencyString(value: monthlyIncomeValue)
            let yearlyString = calculateCurrencyString(value: yearlyIncomeValue)
            // set income labels and their colours
            monthlyIncomeLabel.textColor = UIColor.red
            yearlyIncomeLabel.textColor = UIColor.red
            monthlyIncomeLabel.text = "Monthly Loss: -\(monthlyString)"
            yearlyIncomeLabel.text = "Yearly Loss: -\(yearlyString)"
        }
        
        updateMaximumValues()
    }
    func calculateDividendsTax()
    {
        totalAllowanceYear = personalAllowanceYear + dividendAllowanceYear
        dividendsTaxableIncomeYear = dividendsValueYear + maximumSalaryBeforeNI
        
        switch dividendsTaxableIncomeYear {
        case _ where dividendsTaxableIncomeYear <= totalAllowanceYear:
            dividendsTaxYear = 0.00
        case _ where dividendsTaxableIncomeYear <= basicTaxBracket && dividendsTaxableIncomeYear > totalAllowanceYear:
            dividendsTaxableIncomeYear -= totalAllowanceYear
            dividendsTaxYear = dividendsTaxableIncomeYear * basicDividendsRate
        case _ where dividendsTaxableIncomeYear <= higherTaxBracket && dividendsTaxableIncomeYear > basicTaxBracket:
            dividendsTaxableIncomeYear -= basicTaxBracket
            dividendsTaxYear = dividendsTaxableIncomeYear * higherDividendsRate
            dividendsTaxYear += maxBasicDividendsTax
        case _ where dividendsTaxableIncomeYear > higherTaxBracket:
            return
        default:
            return
        }
        
        
        
    }
    func calculateYearFromSegment(income: Double, segment: UISegmentedControl) -> Double
    {
        let title = segment.titleForSegment(at: segment.selectedSegmentIndex)
        switch title
        {
            case "Day":
                return round(1000*(calculateYear(dayRate: income))/1000)
            case "Year":
                return income
            case "Month":
                return round(1000*(calculateYearFromMonth(monthRate: income))/1000)
            default:
                return 1
        }
    }
    func calculateYear(dayRate: Double) -> Double
    {
        return ( (dayRate * 5) * 46)
    }
    func calculateYearFromMonth(monthRate: Double) -> Double
    {
        return ( (monthRate / 4) * 46)
    }
    func calculateDay(yearRate: Double) -> Double
    {
        return ( (yearRate / 46) / 5 )
    }
    func calculateMonth(yearRate: Double) -> Double
    {
        return ( (yearRate / 46) * 4 )
    }
    func calculateCurrencyString(value: Double) -> String {
        var priceString = currencyFormatter.string(from: NSNumber(value: value))!
        priceString = String (priceString.dropFirst(1))
        return priceString
    }
    func calculateCurrencyDouble(valueString: String) -> Double{
        return currencyFormatter.number(from: valueString)!.doubleValue
    }
    func changeTextField(textField: UITextField, stepper: UIStepper, value: Double) {
        
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        var priceString = currencyFormatter.string(from: NSNumber(value: value))!
        let priceDouble = currencyFormatter.number(from: priceString)?.doubleValue
        priceString = String (priceString.dropFirst(1))
        textField.text = priceString
        stepper.value = priceDouble!
    }
    func checkValidRange(min: Double, max: Double, value: Double) -> Bool
    {
        if value >= min && value <= max {
            return true
        }
        showAlert(min: min, max: max)
        return false
    }
    func checkValidInput(textField: UITextField, min: Double, max: Double) -> Bool
    {
        if let value = Double(textField.text!) {
            if value >= min && value <= max {
                return true
            }
            // only show error if value is not within range, allow user to hit done without entry to keep data unchanged
            showAlert(min: min, max: max)
        }
        return false
    }
    @objc func doneClicked()
    {
        // as event related methods are still tied to obj c, end keyboard
        view.endEditing(true)
    }
    func showAlert(min: Double, max: Double)
    {
        let message = String(format: "Must be within the range of £%.2f-£%.2f.", min, max)
        let alertController = UIAlertController(title: "Invalid Input", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func keyboardWillChange(notification: Notification)
    {
        // extract keyboard height for device, reduce height from view to move screen up, resize to 0 when closed
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            view.frame.origin.y = (-keyboardSize.height) + ( (keyboardSize.height/2) * 1.75)
        } else {
            view.frame.origin.y = 0
        }
    }
    func listenForKeyboardEvents()
    {
        // listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    deinit {
        // stop listening for keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    func setUpCurrency()
    {
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "en_GB")
    }
    func setUpStepperValues()
    {
        incomeStepper.value = incomeValue
        expenseStepper.value = expenseValue
        pensionStepper.value = pensionValue
        mileageStepper.value = mileageValue
    }
    func setUpSegmentedControlFonts()
    {
        // set font to Montserrat
        incomeDayYear.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: font, size: CGFloat(fontSize)) as Any], for: .normal)
        expenseDayYear.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: font, size: CGFloat(fontSize)) as Any], for: .normal)
        pensionMonthYear.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: font, size: CGFloat(fontSize)) as Any], for: .normal)
        mileageDayYear.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: font, size: CGFloat(fontSize)) as Any], for: .normal)
    }
    func setUpToolBarDone() {
        // create toolbar with done button on right hand side for textfields
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        incomeTextField.inputAccessoryView = toolBar
        expenseTextField.inputAccessoryView = toolBar
        pensionTextField.inputAccessoryView = toolBar
        mileageTextField.inputAccessoryView = toolBar
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        updateMaximumValues()
        // set up currency formatter
        setUpCurrency()
        // set init stepper value
        setUpStepperValues()
        // setup done button on toolbars when editing text fields
        setUpToolBarDone()
        // setup fonts for day year switches
        setUpSegmentedControlFonts()
        // listen for keyboard events to push screen up
        listenForKeyboardEvents()
    }
  
}
