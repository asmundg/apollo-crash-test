import SwiftUI
import ApolloAPI
import Apollo

protocol SelectionSet {
  var __data: DataDict { get }
  init(_dataDict: DataDict)
}

struct DataDict {
  let _data: [String: Any]
}

enum SchemaConfiguration: ApolloAPI.SchemaConfiguration {
  public static func cacheKeyInfo(for type: ApolloAPI.Object, object: ObjectData) -> CacheKeyInfo? {
    // Implement this function to configure cache key resolution for your schema types.
    return nil
  }
}

enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  static var configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    return nil
  }
}

class Objects {
  static let Query = ApolloAPI.Object(
    typename: "Query",
    implementedInterfaces: []
  )
}

class GenericQuery: GraphQLQuery {
  public static let operationName: String = "AvailablePromptsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query AvailablePromptsQuery { catchupModule { __typename availablePrompts } }"#
    ))

  public init() {}

  public struct Data: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet {
    public typealias Schema = SchemaMetadata

    public var __data: ApolloAPI.DataDict

    public init(_dataDict: ApolloAPI.DataDict) {
      __data = _dataDict
    }

    public static var __parentType: any ApolloAPI.ParentType { Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [] }
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
