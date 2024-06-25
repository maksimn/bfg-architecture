import SwiftUI
import UIKit

public protocol ViewBuilder {

    func build() -> UIView
}

public protocol ViewControllerBuilder {

    func build() -> UIViewController
}

public protocol SearchControllerBuilder {

    func build() -> UISearchController
}

public protocol SwiftViewBuilder {

    associatedtype ViewType: View

    func build() -> ViewType
}

public protocol FeatureBuilder<FeatureGraph> {

    associatedtype FeatureGraph

    func build() -> FeatureGraph
}
