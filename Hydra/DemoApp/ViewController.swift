//
//  ViewController.swift
//  DemoApp
//
//  Created by Daniele Margutti on 05/01/2017.
//  Copyright © 2017 Daniele Margutti. All rights reserved.
//

import UIKit
import Hydra

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
//        anyPromise1()
//        anyPromise2()
//        anyPromiseErr2()
        anyPromiseErr3()
	}
    
    private func anyPromise1() {
        
        let p1 = Promise(resolved: "hachi")
        let p2 = Promise(resolved: "nobu")
        any([p1, p2]).then { (name) in
            print(name)
        }
        
    }
    
    private func promiseReduce() {
        
        reduce([1, 2, 3], "hachinobu") { (str, num) in
            let s = "\(str)\(num)"
            return Promise(resolved: s)
        }.then { (str) in
            print(str)
        }
        
    }
    
    private func anyPromise2() {
        let p1 = Promise { resolve, reject in
            resolve("hachi")
        }
        let p2 = Promise { resolve, reject in
            resolve("nobu")
        }
        
        any([p1, p2]).then { (name) in
            print(name)
        }
        
    }
    
    private func promiseAll() {
        let a = Promise(resolved: "a")
        let b = Promise(resolved: "b")
        let c = Promise(resolved: "c")
        all([a, b, c]).then { (strs) in
            print(strs)
        }
//        all(a, b, c).then { (strs) in
//            
//        }
    }
    
    private func promiseMap() {
        let strings = ["a", "b", "c", "d"]
        map(as: .parallel, strings) { (str) -> Promise<Int> in
            print(str)
            return Promise(resolved: 1)
        }.then { (nums) in
            print(nums)
        }
    }
    
    private func always() {
        Promise<String> { success, reject in
            reject(PromiseError.rejected)
            }.always {
                print("always")
        }
    }
    
    private func anyPromiseErr() {
        let p1 = Promise { resolve, reject in
            resolve("hachi")
        }
        let p2 = Promise<String> { resolve, reject in
            reject(PromiseError.invalidInput)
//            reject(PromiseError.invalidInput)
//            resolve("nobu")
        }
        
        any([p1, p2]).then { (name) in
            print(name)
        }.catch { (e) -> (Void) in
            print(e)
        }
    }
    
    private func retry() {
        Promise<String> { resolve, reject in
            reject(PromiseError.rejected)
        }.retry()
            .then { (n) in
                print(n)
            }.catch { (e) -> (Void) in
            print(e)
        }
    }
	
    private func anyPromiseErr2() {

        let p1 = Promise<String>(rejected: PromiseError.invalidInput)
        let p2 = Promise(resolved: "adf")
        any([p1, p2]).then { (name) in
            print(name)
            }.catch { (e) -> (Void) in
                print(e)
        }
    }
    
    private func anyPromiseErr3() {
        
        let p1 = Promise<String> { resolve, reject in
            reject(PromiseError.timeout)
        }
        let p2 = Promise<String> { _, reject in
            reject(PromiseError.invalidContext)
        }
        
        any(p1, p2).then { (str) in
            print(str)
        }.catch { (e) -> (Void) in
            print(e)
        }
        
    }
    
	func asyncFunc1() -> Promise<Int> {
		return Promise<Int> { (resolve, reject) in
			delay(2, context: .background, closure: {
				resolve(5)
			})
		}
	}
	
	func asyncFunc2(value: Int) -> Promise<Int> {
		return Promise<Int> { (resolve, reject) in
			delay(2, context: .background, closure: {
				resolve(10*value)
			})
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()

	}


}


func delay(_ delay:Double, context: Context, closure:@escaping ()->()) {
	let when = DispatchTime.now() + delay
	context.queue.asyncAfter(deadline: when, execute: closure)
}
