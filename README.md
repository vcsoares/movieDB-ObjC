# MovieDB ![](https://img.shields.io/badge/iOS-13.0-brightgreen)

This is a simple iOS application that displays various movie-related data fetched from TMDb's API.

## Objective
This project's main purpose was to learn the Objective-C language and its characteristics. As a result, no dependencies were used and everything was written from scratch.

Since Objective-C is still being used in production to this day, knowing your way through the language's intricacies is a valuable skill set an iOS developer can have.

Besides that, having to deal with legacy Objective-C libraries and frameworks in modern Swift projects is not at all uncommon. With this in mind, there's also a second build target that uses part of the previously written Objective-C code, exposing it to a modern SwiftUI client.

## Structure
This project has 2 build targets, aptly titled **moviedb-objc** and **moviedb-swift**.

As previously said, the Objective-C target is entirely written in that language. There are two classes and a delegate protocol that deal with information retrieval, and querying the Movie DB's API is done in three steps:

1. a **Communicator** instance fires a request to fetch data asynchronously from the API; when the request is complete, the resulting raw JSON output is passed to...
2. ...the **CommunicatorDelegate** (in this case, one of the ViewControllers that adhere to this protocol), which responds to it by processing the raw data through...
3. ...the **Parser**, that offers static methods for parsing that data and, in turn, does not require instancing to be used.

If none of these steps fail along the way, the processed data will be returned as an array of **Movie** objects back to the Delegate, which can do whatever is more convenient with it (e.g. displaying those movies in a TableView).

### Usage in a Swift project
The benefits of communicating through Delegate protocols is that it can keep service logic and display logic largely independent from each other. This makes bridging the service classes written in Objective-C into a Swift (and, in this case, SwiftUI) project relatively easy.

After exposing the necessary Objective-C headers to our project via a bridging header, all methods we've previously implemented work out of the box. However, if we want to use them in the context of a SwiftUI application, a few extra things need to be taken care of:

1. **SwiftUI Views are structs**, not classes. The most immediate implication of this is that we cannot subscribe directly to the *CommunicatorDelegate* protocol; instead, we could create another class that instances an internal Communicator *and* subscribes to this protocol. In this case, the class responsible for dealing with fetching and processing data is the **MovieStorage** class.
2. **SwiftUI works best with bindings**. The storage class adheres to the *ObservableObject* protocol, and exposes the fetched movie data as a dictionary. Any changes made to this dictionary, or any of its entries, will be automatically reflected by any View that observes it.
