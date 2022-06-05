import Foundation

let startingArray = ["Swift", "iOS", "Obj-C", "Apple", "Mac"]

class Server {
    static let shared = Server()
    private init() {}
    
    func awesomeifier(_ value: String,
                      completion: @escaping (String) -> Void) {
        
        let delay: Int = Int.random(in: 1...3)
        
        DispatchQueue.global(qos: .background)
            .asyncAfter(deadline: .now() + .seconds(delay)) {
                let awesomeValue = value + " is awesome"
                print(awesomeValue)
                completion(awesomeValue)
            }
    }
}

func processArray() {
    var awesomeArray = [String]()

    let group = DispatchGroup()
    startingArray.forEach { value in
        group.enter()
        Server.shared.awesomeifier(value) { concatenateValue in
            awesomeArray.append(concatenateValue)
            group.leave()
        }
    }

    group.notify(queue: .main) {
        print(awesomeArray)
    }
}

processArray()


//Setup a dispatch group
//group enter for each element
//group leave
//group notify on main thread to consume
