import SwiftUI
import Apollo

protocol SelectionSet {
  var __data: DataDict { get }
  init(_dataDict: DataDict)
}

struct DataDict {
  let _data: [String: Any]
}

enum SchemaConfiguration: Apollo.SchemaConfiguration {
  public static func cacheKeyInfo(for type: Apollo.Object, object: ObjectData) -> CacheKeyInfo? {
    // Implement this function to configure cache key resolution for your schema types.
    return nil
  }
}

enum SchemaMetadata: Apollo.SchemaMetadata {
  static var configuration: any Apollo.SchemaConfiguration.Type = SchemaConfiguration.self

  static func objectType(forTypename typename: String) -> Apollo.Object? {
    return nil
  }
}

class Objects {
  static let Query = Apollo.Object(
    typename: "Query",
    implementedInterfaces: []
  )
}

class GenericQuery: GraphQLQuery {
  public static let operationName: String = "AvailablePromptsQuery"
  public static let operationDocument: Apollo.OperationDocument = .init(
    definition: .init(
      #"query AvailablePromptsQuery { catchupModule { __typename availablePrompts } }"#
    ))

  public init() {}

  public struct Data: Apollo.SelectionSet & Apollo.RootSelectionSet {
    public typealias Schema = SchemaMetadata

    public var __data: Apollo.DataDict

    public init(_dataDict: Apollo.DataDict) {
      __data = _dataDict
    }

    public static var __parentType: any Apollo.ParentType { Objects.Query }
    public static var __selections: [Apollo.Selection] { [] }
  }
}

func testCrash<Q: GraphQLQuery>(q: Q) {
    let result = Apollo.GraphQLResult<Q.Data>(data: nil,
                                    extensions: nil,
                                    errors: nil,
                                    source: .cache,
                                    dependentKeys: nil)
  
    let wrapped = Result<Apollo.GraphQLResult<Q.Data>, Error>.success(result)

  // fine
  print(result)
  // crash
  print(wrapped)
}

@main
struct ApolloCrashTestApp: App {
    init() {
      testCrash(q: GenericQuery())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
