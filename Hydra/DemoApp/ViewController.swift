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
//        thenPromise()
//        catchPromise()
//        alwaysPromise()
//        validatePromise()
//        passPromise()
//        recoverPromise()
//        retryPromise()
//        timeoutPromise()
//        deferPromise()
//        reducePromise()
//        allPromise()
//        mapPromise()
//        anyPromise()
//        zipPromise()
//        async1()
//        async2()
//        await1()
//        asyncAwait()
        semaphore()
	}
    
    private func semaphore() {
        
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2.0) { 
            print("async")
            semaphore.signal()
        }
        
        //semaphoreのおかげでwaitがasyncの後にprintされる
        _ = semaphore.wait(timeout: DispatchTime(uptimeNanoseconds: UInt64.max))
        print("wait")
        
    }
    
    private func promise() {
        
        Promise<Int>(resolved: 10)
        Promise<Int>(rejected: PromiseError.timeout)
        
        let promise = Promise { resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1.0) {
                resolve("hachinobu")
            }
        }
        
    }
    
    private func thenPromise() {
        
        Promise<String> { resolve, reject in
            
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1.0) {
                resolve("hachinobu")
            }
        }.then { result -> Int in
            print(result)
            return 100
        }.then { result -> Promise<Date> in
            print(result)
            return Promise(resolved: Date())
        }.then { result in
            print(result)
        }
        
    }
    
    private func catchPromise() {
        
        Promise<String>{ resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1.0) {
                reject(PromiseError.rejected)
            }
        }.catch { error in
            print(error)
            throw PromiseError.timeout
        }.then { void in
            print("pun")
        }.catch { e in
            print(e)
        }
        
    }
    
    private func alwaysPromise() {
        
        //catchの後だとPromise<Void>になるのでcatchより前にthenを書くこと
        Promise { resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1.0) {
                resolve("hachinobu")
            }
            }.always {
                print("always")
        }.then { result in
            print(result)
            }.always {
                print("always2")
        }.then { (result) -> Int in
            return 888
//            throw PromiseError.invalidInput
            }.always {
                print("always3")
            }.then { result in
                print(result)
            }.catch { (e) -> (Void) in
                print(e)
            }.always {
                print("always4")
        }
        
    }
    
    private func validatePromise() {
        
        Promise { resolve, reject in
            resolve("hachinobu")
        }.validate { result in
            result == "8nobu"
        }.then { result in
            print(result)
        }.catch { e in
            print(e)
        }.then { (result) in
            print("after catch")
        }
        
    }
    
    private func recoverPromise() {
        
        Promise<String> { resolve, reject in
            
            print("start")
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1.0) {
                reject(PromiseError.timeout)
            }
        }.recover { error -> Promise<String> in
            print("recover")
            throw PromiseError.rejected
//            return Promise(resolved: "hachinobu")
        }.then { result in
            print(result)
        }.catch { e in
            print(e)
        }
        
    }
    
    private func passPromise() {
        
        Promise { resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1.0) {
                resolve("hachinobu")
            }
        }.pass { result -> Promise<Int> in
            print("pass \(result)")
            return Promise(resolved: 8)
        }.then { result in
            print(result)
        }
        
    }
    
    private func retryPromise() {
        
        Promise<String> { resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1.0) {
                reject(PromiseError.rejected)
//                resolve("hachinobu")
            }
        }.retry(3) { (num, error) -> Bool in
            print("retry")
            return num != 0
        }.then { result in
            print(result)
        }.catch { err in
            print(err)
        }
        
    }
    
    private func timeoutPromise() {
        
        Promise<String> { resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 3.0) {
//                reject(PromiseError.rejected)
                resolve("hachinobu")
            }
        }.timeout(timeout: 2.0).then { result in
            print(result)
        }.catch { err in
            print(err)
        }
        
    }
    
    private func deferPromise() {
        
        Promise { resolve, reject in
            resolve("hachinobu")
        }.defer(3.0).then { result in
            print(result)
        }
        
    }
    
    private func reducePromise() {
        
        reduce(["ha", "chi", "no", "bu"], 0) { (num, item) -> Promise<Int> in
            Promise(resolved: num + 1)
        }.then { result in
            print(result)
        }
        
    }
    
    private func allPromise() {
        let promise1 = Promise(resolved: "hachi")
        let promise2 = Promise<String> { resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 3.0) {
                resolve("hachinobu")
            }
        }
        
        all(promise1, promise2).then { results in
            print(results)
        }.catch { e in
            print(e)
        }
        
    }
    
    private func mapPromise() {
        
        map(as: .series, ["ha", "chi", "no", "bu"]) { str -> Promise<String> in
            return Promise(resolved: "\(str) 8")
        }.then { (results) in
            print(results)
        }
        
    }
    
    private func anyPromise() {
        
        let promise1 = Promise<String> { resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 3.0) {
                print("justin")
                resolve("hachi")
            }
        }
        let promise2 = Promise { resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2.0) {
                return resolve("nobu")
            }
        }
        
        any(promise1, promise2).then { result in
            print(result)
        }
        
    }
    
    private func zipPromise() {
        
        let promise1 = Promise { resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2.0) {
                resolve("hachinobu")
            }
        }
        
        let promise2 = Promise { resolve, reject in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2.0) {
                resolve(888)
            }
        }
        
        Promise<Void>.zip(promise1, promise2).then { (str, num) -> Void in
            print(str)
            print(num)
        }
        
    }
    
    private func async1() {
        
        async { _ in
            return "hachinobu"
        }.then { result in
            print(result)
        }
        
    }
    
    private func async2() {
        
        async(in: .background, after: 2.0) { _ in
            print("hachi")
        }
        
    }
    
    private func await1() {
        
        async { _ -> String in
            
            let promise1 = Promise(resolved: "hachinobu")
            let promise2 = self.asyncFunc1()
            
            let name = try await(promise1)
            print(name)
            
            let num = try await(promise2)
            print(num)
            
            let result = try await({ (resolve: @escaping (String) -> (), reject: @escaping (Error) -> ()) in
//                reject(PromiseError.rejected)
                resolve("aaaaa")
            })
            
            return "\(name) \(num) \(result)"
            
        }.then { result in
            print(result)
        }.catch { e in
            print(e)
        }
        
    }
    
    private func asyncAwait() {
        
        async { () -> String in 
            
//            let result1 = try ..Promise<String>(resolved: "hachinobu")
//            let result2 = try ..Promise<Int>(resolved: 8)
//            
//            return "\(result1) + \(result2)"
            
            do {
                
                let result1 = try ..Promise(resolved: "hachinobu")
                let result2 = try ..Promise(resolved: 8)
                
                return "\(result1) + \(result2)"
            } catch {
                throw PromiseError.invalidInput
            }
            
        }.then { result in
            print(result)
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
