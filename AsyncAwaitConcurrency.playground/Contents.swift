
import Foundation
import _Concurrency

let startingArray = ["Swift", "iOS", "Obj-C", "Apple", "Mac"]

class Server {
    static let shared = Server()
    private init() {}
    
    func awesomeifier(_ value: String, completion: @escaping (String) -> Void) {
        print(value)
        let delay: Int = Int.random(in: 1...3)
        let queue = DispatchQueue.global(qos: .background)
        queue.asyncAfter(deadline: .now() + .seconds(delay), execute: {
            let concatString = value + " is awesome"
            print("concatenate: " + concatString)
            completion(concatString)
        })
    }
}

extension Server {
    func asyncAwesomeifier(_ value: String) async -> String {
        return await withUnsafeContinuation { continuation in
            self.awesomeifier(value) {
                continuation.resume(returning: $0)
            }
        }
    }
}

func processArray() async {
    var awesomeArray = [String]()
    
    await withTaskGroup(of: String.self) { group in
        startingArray.forEach { value in
            group.addTask {
                return await Server.shared.asyncAwesomeifier(value)
            }
        }
        
        for await awesomeValue in group {
            awesomeArray.append(awesomeValue)
        }
    }
    
    print(awesomeArray)
}

Task {
    await processArray()
}

//Wrap legacy async API in a function that calls a continuation in its closure
//setup with Task Group
//addTasks to the goup
//call the async function in each group
//extract values from the group and put them in my array
//print the array
//Call the kickoff function from a Task

//Upside is that is is possible to cancel all the Task group processes.
//It is also a lot cleaner if used with a modern async API.



