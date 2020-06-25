//
//  StatisticViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

private enum CurrentEditingTextView {
    case fromDate, toDate
}

private enum Constants {
    static let statisticCellHeight: CGFloat = 100
    static let openFilterDuration: Double = 0.3
    static let filterIconName = "filterIcon"
}

class StatisticViewController: BaseViewController {
    
    @IBOutlet private weak var statisticTableView: UITableView!
    @IBOutlet private weak var fromDateFilterTextField: UITextField!
    @IBOutlet private weak var toDateFilterTextField: UITextField!
    @IBOutlet private weak var resetFilterButton: UIButton!
    @IBOutlet private weak var applyFilterButton: UIButton!
    @IBOutlet private weak var filterView: UIView!
    @IBOutlet private weak var filterViewTopConstraint: NSLayoutConstraint!
    
    private let datePicker = UIDatePicker()
    private let toollbar = UIToolbar()
    
    private let currentEditingView = BehaviorRelay<CurrentEditingTextView?>(value: nil)
    private let isFilterOpen = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        setupViewPreferences()
        super.viewDidLoad()
    }
    
    private var loginViewModel: StatisticViewModel? {
        return viewModel as? StatisticViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = loginViewModel else {
            return
        }
        
        statisticTableView.rx
            .setDelegate(self)
            .disposed(by: rxBag)
        
        statisticTableView.register(UINib(nibName: StatisticCell.reuseIdentifier, bundle: Bundle.main),
                                    forCellReuseIdentifier: StatisticCell.reuseIdentifier)
        
        viewModel.weakStatisticData
            .bind(to: statisticTableView
                .rx
                .items(cellIdentifier: StatisticCell.reuseIdentifier,
                       cellType: StatisticCell.self)) { row, weakStatistic, cell in
                        cell.configure(with: weakStatistic)
            }
        .disposed(by: rxBag)
        
        viewModel.fromFilterDate
            .filterNil()
            .map { [weak self] in self?.dateStringFormat(from: $0) }
            .filterNil()
            .bind(to: fromDateFilterTextField.rx.text)
            .disposed(by: rxBag)
        
        viewModel.toFilterDate
            .filterNil()
            .map { [weak self] in self?.dateStringFormat(from: $0) }
            .filterNil()
            .bind(to: toDateFilterTextField.rx.text)
            .disposed(by: rxBag)
        
        applyFilterButton.rx.tap
            .bind(onNext: viewModel.applyFilter)
            .disposed(by: rxBag)
        
        resetFilterButton.rx.tap
            .bind(onNext: viewModel.resetFilter)
            .disposed(by: rxBag)
        
        fromDateFilterTextField.rx.controlEvent(.editingDidBegin)
            .map { _ in CurrentEditingTextView.fromDate }
            .bind(to: currentEditingView)
            .disposed(by: rxBag)
        
        toDateFilterTextField.rx.controlEvent(.editingDidBegin)
            .map { _ in CurrentEditingTextView.toDate }
            .bind(to: currentEditingView)
            .disposed(by: rxBag)
        
        datePicker.rx.date.asDriver()
            .drive(onNext: { [weak self] date in
                guard let editingView = self?.currentEditingView.value else {
                    return
                }
                switch editingView {
                case .fromDate:
                    viewModel.fromFilterDate.accept(date)
                case .toDate:
                    viewModel.toFilterDate.accept(date)
                }
            }).disposed(by: rxBag)
        
        isFilterOpen.subscribe { [weak self] isOpen in
            self?.setFilter(isOpen: isOpen.element ?? false, animated: true)
        }.disposed(by: rxBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(onNext: { [weak self] in
                self?.isFilterOpen.accept(!(self?.isFilterOpen.value ?? false))
            }).disposed(by: rxBag)
    }
    
    private func setupDatePicker() {
        toollbar.sizeToFit()
        datePicker.datePickerMode = .date
        fromDateFilterTextField.inputAccessoryView = toollbar
        fromDateFilterTextField.inputView = datePicker
        toDateFilterTextField.inputAccessoryView = toollbar
        toDateFilterTextField.inputView = datePicker
    }
    
    private func setFilter(isOpen: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? Constants.openFilterDuration: .zero) {
            self.filterViewTopConstraint.constant = isOpen ? .zero: -self.filterView.frame.height
            self.filterView.superview?.layoutIfNeeded()
        }
    }
    
    private func setupViewPreferences() {
        statisticTableView.rowHeight = Constants.statisticCellHeight
        statisticTableView.backgroundColor = .clear
        setupDatePicker()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.filterIconName),
                                                           style: .plain,
                                                           target: self,
                                                           action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .yellow
    }
    
    private func dateStringFormat(from date: Date?) -> String? {
        guard let date = date else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }
}

extension StatisticViewController: UITableViewDelegate {}
