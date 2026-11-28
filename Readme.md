# The Builder-Feature-Graph Architecture.

The Builder-Feature-Graph Architecture (the BFG Architecture, or BFGA for short) is a general architectural approach for complex, large-scale iOS applications. 

This approach focuses on creational code and its composition rather than on a specific framework or pattern, such as MVP, MVVM, RIBs, or TCA. 

* [Origins of the BFG Architecture](#origins-of-the-bfg-architecture)
* [A General Guide to Architecture and App Feature Development](#a-general-guide-to-architecture-and-app-feature-development)
* [Builders](#builders)
* [Feature Graph](#feature-graph)
* [Communication between features](#communication-between-features)
* [The BFGA example](#the-bfga-example)

## Origins of the BFG Architecture

The BFGA draws from several sources:

* **Uber’s RIBs mobile architecture framework**, from which the concept of a _Builder_ is adapted.
* **Yandex’s graph-module approach**, from [which](https://www.youtube.com/watch?v=iN8BtJxRBWs) the concept of a _Graph_ originates.
* Other established architectures and design patterns, including SOLID principles, MVC, MVP, MVVM, VIPER, and Unidirectional Data Flow.

## A General Guide to Architecture and App Feature Development.

An application is structured as a __feature tree__. A __feature__ is an entity that represents a distinct piece of product functionality or fulfills a critical role within the product. 

A feature may rely on services or other types of dependencies, though the distinction between features and dependencies can sometimes be subjective. 

Avoid using global objects, global variables, or any implicit dependencies. 

## Builders

A feature is instantiated by a _builder_. In general, a builder follows this structure: 

```swift
protocol FeatureBuilder {
    func build() -> FeatureGraph
}

final class FeatureBuilderImpl: FeatureBuilder {

    init(/* external dependencies */) {
        // ...
    }

    func build() -> FeatureGraph {
        // ...

        return FeatureGraphImpl(/* feature dependencies */)
    }
}
```

The primary purpose of a builder is to invoke a __feature graph__ initializer with the required dependencies. Every feature maintains its own dependency scope: external dependencies are passed into the builder's initializer, while internal dependencies are defined within the builder's scope. 

A feature's builder is instantiated by the builder of its parent feature. The parent feature is responsible for selecting an implementation of the child feature's builder and supplying its dependencies. Beyond this relationship, parent and child features do not require any further logical coupling. 

To integrate a feature into a project component, pass the feature's builder into that component's initializer. 

## Feature Graph

In short, a __*feature graph*__ is a dependency injection (DI) container that exposes functional outputs for use across a project. 

A [video](https://www.youtube.com/watch?v=iN8BtJxRBWs) from Yandex explaining the concept of a feature graph.

```swift
protocol AppGraph {

    var firstScreen: UIViewController { get }

    var pushNotificationHandler: AppPushNotificationHandler { get }
}

protocol SomeGraph {

    var view: UIView { get }

    var model: SomeModel { get }
}
```

A feature graph is a general pattern intended for features with two or more outputs. If a feature is represented by a single object, a feature graph is redundant. For example, if a feature consists of only a single screen, its builder should be structured as follows

```swift
protocol ViewControllerBuilder {
    func build() -> UIViewController
}

final class SomeScreenBuilder: ViewControllerBuilder {
    // ...
}
```

## Communication between features

If two features have a parent-child relationship, the parent can act as a delegate for the child. 

```swift
protocol FeatureListener: AnyObject {
    func onSomeDataChanged(_ data: SomeData)
}
```

Communication between distant features can be implemented using the following approaches: 

1) `NotificationCenter` or strictly-typed wrappers around it.

2) [Rx Model Streams](https://github.com/uber/RIBs/wiki/iOS-Tutorial-3).

3) Unidirectional Data Flow frameworks.

## The BFGA example

[Personal Dictionary](https://github.com/maksimn/personal-dictionary-ios) is a sample project built using the BFGA approach. The application's feature tree is structured as follows

![alt text](https://raw.githubusercontent.com/maksimn/personal-dictionary-ios/main/pers-dict-arch.png "")

`B` - builder, `G` - graph, `R` - router, `V` - view, `VC` - ViewController, `MVVM` - UI pattern, `UDF` - Unidirectional Data Flow, `D` - domain.

## Community Engagement

Discussion regarding architectural challenges and potential issues is strongly encouraged. 

If you have questions about this approach or have noticed any errors, please feel free to share your feedback.

[My contact](https://t.me/maksimiv).
