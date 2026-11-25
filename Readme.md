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

The BFGA has several sources:

* **Uber’s RIBs mobile architecture framework**, from which the concept of a _Builder_ is adapted.
* [Yandex’s graph-module approach](https://www.youtube.com/watch?v=iN8BtJxRBWs), from which the concept of a _Graph_ originates.
* Other established architectures and design patterns, including SOLID principles, MVC, MVP, MVVM, VIPER, and Unidirectional Data Flow.

## A General Guide to Architecture and App Feature Development.

An app is implemented as a __feature tree__. __Feature__ is an entity that represents product functionality or carries out an important role in a product.

A feature can use services or other types of dependencies. The distinction between features and dependencies can be subjective.

Do not use global objects, variables and any implicit dependencies.

## Builders

A feature is instantiated by a _builder_. In general, a builder looks like:

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

A goal of a builder is to call a __feature graph__ initializer with required dependencies. Every feature has its own dependency scope. The feature gets external dependencies from the initializer of its builder. Inner dependencies are defined inside the scope of the builder.

A builder of a feature is created by a builder of a parent feature. A task of the parent feature is to choose an implementation of the builder of the child feature and to pass dependencies to it. These features do not have to have other logical connections between each other.

To include a feature in a component of a project you need to pass a builder of the feature to an initializer of the component.

## Feature Graph

In short, a __*feature graph*__ is a DI-contaner having an output of functionality that can be used in a project.

A [video](https://www.youtube.com/watch?v=iN8BtJxRBWs) from Yandex where a concept of feature graph is explained.

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

A feature graph is a general concept for a feature having two or more outputs. If a feature is represented as a single object then the feature graph is redundant. For example, if a feature consists of an only screen then a builder should look like this:

```swift
protocol ViewControllerBuilder {
    func build() -> UIViewController
}

final class SomeScreenBuilder: ViewControllerBuilder {
    // ...
}
```

## Communication between features

If two features relate to each other in a child-parent way then you can make a parent to be a delegate of a child:

```swift
protocol FeatureListener: AnyObject {
    func onSomeDataChanged(_ data: SomeData)
}
```

Communication between 'distant' features can be arranged as follows:

1) `NotificationCenter` or strictly-typed wrappers around it.

2) [Rx Model Streams](https://github.com/uber/RIBs/wiki/iOS-Tutorial-3).

3) Unidirectional Data Flow frameworks.

## The BFGA example

[Personal Dictionary](https://github.com/maksimn/personal-dictionary-ios) is a project that is based on the BFGA approach. A feature tree of the app is

![alt text](https://raw.githubusercontent.com/maksimn/personal-dictionary-ios/main/pers-dict-arch.png "")

`B` - builder, `G` - graph, `R` - router, `V` - view, `VC` - ViewController, `MVVM` - UI pattern, `UDF` - Unidirectional Data Flow, `D` - domain.

## Appeal to the Community

Discussion of architectural problems and issues is encouraged. 

If you have questions about this approach or have noticed any mistakes, please, inform about it. 

[My contact](https://t.me/maksimiv).
