//
//  ViewController.swift
//  RxSwiftExample
//
//  Created by Yasser Mabrouk  on 11/7/19.
//  Copyright © 2019 Yasser Mabrouk . All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
   
    let disposeBag = DisposeBag()

    var shownCities = [String]() // Data source for UITableView
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        
        let bag = DisposeBag()
  
        
   let helloSequence = Observable.from(["H","e","l","l","o"])
//        let subscription = helloSequence.subscribe { event in
//          switch event {
//              case .next(let value):
//                  print("next\(value)")
//              case .error(let error):
//                  print("error\(error) ")
//              case .completed:
//                  print("completed")
//          }
//        }
        // Adding the Subscription to a Dispose Bag
//           subscription.disposed(by:bag)
        
          print(#line,"helloSequence ended")
//        var publishSubject = PublishSubject<String>()
        
        var publishSubject = BehaviorSubject<String>(value: "Starting value")
        
        publishSubject.onNext("Hello")
        publishSubject.onNext("World")
        
        
        let subscription1 = publishSubject.subscribe(onNext:{
            print(#line,$0)
        }).addDisposableTo(bag)
        // Subscription1 receives these 2 events, Subscription2 won't
        publishSubject.onNext("Hello")
        publishSubject.onNext("Again")
        // Sub2 will not get "Hello" and "Again" because it susbcribed later
        let subscription2 = publishSubject.subscribe(onNext:{
          print(#line,$0)
        })
        publishSubject.onNext("Both Subscriptions receive this message")
        
        searchBar
            .rx.text // Observable property thanks to RxCocoa
//            .throttle(0.5, scheduler: MainScheduler.instance)
            .orEmpty // Make it non-optional
            .distinctUntilChanged()
        .throttle(0.5, scheduler: MainScheduler.instance)
   .subscribe(onNext: { [unowned self] query in // Here we will be notified of every new value
        print("query was ..... \(query)")
    self.shownCities = self.allCities.filter { $0.hasPrefix(query) || $0.hasSuffix(query) } // We now do our "API Request" to find cities.
       self.tableView.reloadData() // And reload table view data.
            })
    .disposed(by: disposeBag)
        
//        searchBar
//        .rx_text // observable property
//        .throttle(0.5, scheduler: MainScheduler.instance) // wait 0.5 seconds for changes
//        .distinctUntilChanged() // check if the new value is the same as the old one
//        .filter { $0.characters.count > 0 } // filter for a non-empty query
//        .subscribeNext { [unowned self] (query) in // get notified of every new value
//            self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // do the "API Request" to find cities
//            self.tableView.reloadData() // reload data in table view
//        }
//        .addDisposableTo(disposeBag)
        
        
//       searchBar
//        .rx.text // Observable property thanks to RxCocoa
//        .orEmpty // Make it non-optional
//        .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
//        .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
//        .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
//        .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
//            self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
//            self.tableView.reloadData() // And reload table view data.
//        })
//        .addDisposableTo(disposeBag)
    }

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        
        return cell
    }
    



}

