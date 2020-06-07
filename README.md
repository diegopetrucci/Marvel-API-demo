# Marvel API demo
A master-detail client for the Marvel API in SwiftUI and Combine

## General overview
This is very much a work in progress, as conventions and general practices are still up in the air for SwiftUI (and bugs are plenty). I'm sure in a few weeks, when WWDC 2020 "airs", this project will look already outdated — and that's great, technology moves on and new ways of working are continuously created.

A general note before starting: while I've done the project using SwiftUI, and I've strived to write production-grade code, I would say the end result is not — SwiftUI is just not ready yet. Even in this relatively small project there are quite a few bugs that just wouldn't be there with UIKit (or even one of the already present declarative UI layers out there!). As an example, superhero photos in the `My squad` list appear and disappear seemingly randomly, and they sometimes flicker too. Or the main picture in the hero detail page does not ever load as `viewWillAppear` is never triggered. And let's not talk about `ScrollView`s :). Not even just bugs, but important APIs are missing too: there's no way of doing work in `viewWillAppear`, which would have suited this project a lot more making the UI transitions smoother.

This notwithstanding, I've enjoyed playing with it and with Combine. It is very clearly the way forward for a lot of UI work in the future, even if not all, and the ease of development is increased greatly. Combine, in particular, I believe to be more ready than SwiftUI — I would bet that its adoption is a lot faster than its cousin.

Onto the project.

The architecture for this demo is MVVM, which I've found to fit quite nicely with the way SwiftUI works. Moreover, it follows the unidirectional data flow principles to make sure changes are always safe to perform and easy to understand. I've been using redux at work and in personal projects and I've found it to be very adaptable to most scenarios. It's not perfect, but these state machines definitely help with most problems derived from handling state. In particular, it becomes really easy to avoid impossible states, something that plagues even Apple's own APIs (e.g being able to, theoretically, receive a `nil` `Data`, a status response with code `200 OK`, and an error from a network request). This kind of finite state machines and redux-like approach definitely make the codebase scream for a reactive approach to data/events management and a tree rendering for UI, but I believe it would be interesting to see them in a plain UIKit situation too. Maybe a thought for another exercise.

UI-wise, I've had to fight _a lot_ with SwiftUI. It is miles ahead of UIKit for simplicity and ease of use, and yes it does feel natural, but it also has severe limitations. I'm sure a lot of them will go away, but as it kind of happened with Swift, we will learn to either work around them or drop them completely in favor of new paradigms and patterns. I don't have much experience with Objective-C, but the way Swift literally does not permit you to perform "impossible" actions really reminds me of some SwiftUI quirks.  

The experiment has been fun, but I would _strongly_ advise against using SwiftUI in production. Maybe rewriting a settings screens, or a debug tool so as to get familiarity with it, but not much. I do hope for WWDC to radically change this, but even then, we would be thinking of at least September-October for the changes to be stable and available, and realistically early/mid next year for something _safe_.

### Pull Requests and how to go through the code
The code is organized via a number of smaller PRs, to be read sequentially. I've chosen to do so to make the reviewer's life easier: as much as I trust my code it inherently shows my biases, even when tests are added, and so I _need_ other people to review it thoroughly and check that it is, at least in theory, correct. Also, what might make sense in my head might not to other people, so this prevents domain or context black holes.

Smaller PRs for me mean less code to be evaluated, and even better if they only pertain to a specific domain — for example, some UI changes or a backend model. This, however, increases the possibility of the reviewer losing sense of the big picture. In my experience, this is not a big problem if the app's architecture is standardized, or close to, but in case it's not it would be very helpful to have a chat about the architecture first, and when implemented, a catchup overview to fill in possible holes in the reviewer's context. Obviously this all depends on the size of the change, a 300 lines change is not the same as this project, where concepts like reactive programming and state machines might be introduced.

Another note on the PRs: I've gone with UI first instead of setting up the infrastructure (FSMs, networking, persistence, etc) immediately. For this particular project it's mostly because I did not want to pollute the PRs too much, but in general I quite like to go UI first as it forces me to think about what the views need, and not more than that — if the actual backend response contains more information, well, the view models have to strip it and map it. This is obviously truer for bigger responses that are not necessarily geared towards UI, but if there is a backend-for-fronted-like middleware between the two this tends to be less applicable.  


## Technical explanations

#### Xcode project structure
Files on Xcode are divided by UI, data provider, networking, persistence, and utils:

* UI: views, view models, view-specific objects (to map DTOs), and tests
* DataProvider: data provider (the mediator between network and persistence), tests
* Networking: DTOs and responses, the marvel-specific API, a generic object (Remote) that interfaces with URLSession, and tests
* Persistence: persisters to wrap Disk API, tests
* Utilities: various helpers

#### UI quirks

1. As apparent when launching the app, the status bar is not colored by the background color. I've not found yet a satisfactory way of doing this in SwiftUI.
2. As mentioned in the introduction, pushing to the HeroDetailView does not work when the user taps one of the `My squad` members. The problem seems to be [shared by many](https://stackoverflow.com/questions/57946197/navigationlink-on-swiftui-pushes-view-twice), and even trying the proposed solutions does not work. SwiftUI seems to be not ready to handle `ScrollView`s properly yet. This also seems to be messing up the avatars for the heroes in the section, as they lose the downloaded image. The code to fetch it and display it is shared between _all_ images (`AsyncImageView`), so it could very well be a SwiftUI bug.
3. Adding a `ScrollView` to the `HeroDetail` screen makes it crash. I've not found yet a good solution to this, and I do believe it's a bug. Scroll views in SwiftUI are really really really buggy.
4. Images are not displayed correctly all the time. Again, as the code to fetch them is shared, that is likely not the problem. Instead, it's probably a layout problem, as playing around with different (but not similar to the spec) layouts fixes the issue.
5. Even though I've assigned a background color to _every single_ view, a white part still shows up when scrolling the root view. It looks again like it's a ScrollView issue. Have I mentioned how buggy they are?
6. The button to remove a superhero from the squad looks odd. In specific it has an internal frame that does not have a `cornerRadius`, but the border has it. Doing the intuitive thing of applying a cornerRadius to the internal frame too makes the button shrink considerably ending up hugging the text. Another SwiftUI bug.
7. It would be better for the UI changes to be triggered in `viewWillAppear` and not `viewDidAppear`, as the reloading is apparent to the user. This is currently not possible with SwiftUI.
8. Images in the `My Squad` section disappear when coming back from the detail view. I am not sure of what's the cause of this, as I've tried two approaches (or three, even, with AsyncImage v1, v2, and +hack). Maybe a SwiftUI bug, a layout system quirk, or just my logic mistake.
         

#### Data provider

Data providers are modeled with Protocol witnessed, aka generic structs. A "base" one is created, `DataProvider`, to hold the API and persister, and all subsequent concrete implementations are created as computed properties using the API and the persister.
Data providers orchestrate where the data should come from, and I've chosen to always favor the API over what is persisted, as the latter might be outdated. Different apps have different requirements so this might be rethought for other scenarios.

#### Networking
Networking should be pretty much self-explanatory. It is set up to be as light as possible, with the usual protocol-first approach. `Remote` takes care of the `URLSession` API, errors, and decoding the result — all very concise thanks to Combine.

Downloading images, too, is done in a native way, and it uses a little helper wrapper `AsyncImage` to fetch the image upon request. It does not support canceling, but that can be added in a future revision.

I have not added support to automatic retrying if the network is unreachable, but it shouldn't be a massive effort due to the nature of the architecture.

#### Persistance
While networking is pretty much "clean", as in it does not introduce external libraries, I've chosen to do it for persistence to disk. I use the aptly named `Disk` library, and not Realm, just because I wanted the lightest possible dependency while still being able to avoid the many edge cases of persisting data to disk.

Speaking of Realm, I am not sure if the API is still the same, but I tried it when I was learning iOS development and it was forced upon the client to use `class`es instead of `struct`s. Various problems with, one, mutating the same object from different places, and two, trying to read the same object from different threads have burned into my soul the importance of value types and the avoidance of race conditions. I did not really what those terms meant at the time, but I intuitively got the pain associated with them. :)

#### State machines and unidirectional data flow
I've already briefly touched on this in the intro, but it might be worth a few more words.

State machines to me are one of those ideas that after being exposed to them they kind of make you go like "wow, how did I live before this". Maybe it's due to not having had a computer science background, so the term and the ideas were new to me until they got introduced in my previous codebase. I enjoy a lot being able to craft a state in such a way that changes can happen only so far as to make _correct_ states, making incorrect one impossibles to reach (bugs aside…). Apple does _some_ of this in its code examples when it uses enums to represent view states, but more can be done.

Unidirectional data flow, too, is really nice to work with. Just like state machines, it feels incredibly restrictive at first, but that goes away with experience. Having only one place where the state can be changed, the View Model, means containing a good variety of bugs that would have happened otherwise.

SwiftUI generally works well with these two, but it does break down when having to switch over enums and working with optionals. However support for both is coming soon, so the ugly workarounds that I had to implement for them to work are luckily getting deprecated shortly.

Regarding the concrete implementation of the FSMs and UDF, I have borrowed Vadym Bulavin's implementation, which while not extensive is good enough for a project this size. The PointFree guys have done some very good work on theirs, too, and it's interesting how they've decided to go with a single composable store (I do however wonder if it scales well with bigger apps, it would be nice to test it).

##### A note on why all data is passed around in `Status`es
I would normally structure `State`s to hold information, e.g:

```
struct State {
    var status: Status
    var superhero: Superhero?
}
```
Instead, I had to effectively pass any data change via `Status`es, making it look like this:

```
enum Status {
    case idle
    case loading
    case loaded(Superhero)
    case persisted(Superhero)
}
```
I do not think that having this sprawl of statuses is the correct way of handling it. However, SwiftUI not (yet) having support for optional binding and means we cannot easily do something like

```
if let superhero = viewModel.state.superhero {
    SuperheroView(with: superhero)
}
```
Fortunately, support for it will come soon and these workarounds will be removed.

#### Container views
I've decided to go with one container view per screen, i.e. one for the root view and one for the detail. Every single UI component is then extracted into a subview (with a specific view model if necessary). Container builds all child views, including the ones being pushed by navigation (see next section). I do like this approach, but I'm sure it's not perfect — maybe there could be a single reducer/store a-la Pointfree, or maybe one per container view, maybe container views should not handle navigation, and so on. The exciting part of SwiftUI is that we're building all these conventions in real-time and it's such an exhilarating thing.

#### Abstracting Navigation and Coordinators
SwiftUI hardcodes the handling of navigation inside the views that are triggering it with `NavigationLink`. There's not too much that we can do to abstract it away, but at least we can avoid having the presenting view know about the presented view by having the latter injected in it via a closure. Destination views are built-in container views, so single responsibility principles are maintained. Another interesting solution [has been proposed](https://twitter.com/ilyapuchka/status/1254411158330773504) by my friend Ilya and I do feel like something like it might even be more suitable.

Coordinators, I don't feel like there's much need for them in SwiftUI. Presenting and building a view is a lot simpler in SwiftUI than UIKit and it saves us a lot of boilerplate, and using coordinators seems like having a hammer and seeing every problem as a nail.

#### Testing: stubs, SwiftUI Previews, and #if DEBUGs
There are a lot of `if #DEBUG`s scattered in the code. They mainly serve the purpose of providing stub data (fixtures) for tests and SwiftUI Previews. Ideally, these should not live in the same target as the "live" code, but instead be stored in the unit tests target. However, due to SwiftUI Previews not following this principle, we cannot really do that for now — hence, they being declared right next to the object.

Another concession that I had to make for testing purposes is having to make the view model's `state`s not private (I usually prefer to have it so `@Published private(set) state: State` as to avoid another object mutating it. I've been trying to find a way to avoid it but it gets… tricky. I will definitely explore this further in the future as it's really important.

Lastly, I regrettably had to skip over testing `view model`s. Arguably this is the most important piece of code to be tested, as they power all the logic changes within the app. However, to keep with my self-imposed time limit of not going over the weekend something had to give. I haven't had the chance to write infrastructure for them yet, I need to explore further how to use test schedulers in Combine. What I would do, however, is this: set up the view model (with a test scheduler) and trigger a UI event (e.g: `viewDidAppear`). Then, check every state change to make sure it's the correct one. Then, trigger something else (e.g: `viewWillDisappear`) and repeat until satisfied.

#### Tests next to (actually, inside!) the features
Unit and snapshot tests are located in the same folder as to features. There's a good [explanation by Brandon Williams](https://kickstarter.engineering/why-you-should-co-locate-your-xcode-tests-c69f79211411?gi=fe48007b43d0) as to why this is useful. For me, it's just a matter of practicality — as the codebase grows, we tend to develop and stay on a single feature for longer times, so it becomes increasingly harder to look for related files in different places. Tests still belong to different targets, however.

For bigger codebases, there's an argument to be made to create a separate target to make the engineer able to run snapshot tests independently from the unit. They run fast in this demo app, so I've found no need to do so at the moment.

#### Protocol witnesses
A few of the generic interfaces, like data providers, are implemented using protocol witnesses. PW are how protocols are implemented under the hood, and by making the generic interface a struct we usually gain a bit of flexibility — no `Protocol … can only be used as a generic constraint because it has Self or associated type requirements` anymore, to start. I like them, I think they make life slightly easier, but they do take a while to get used and look a bit odd at first and have some drawbacks (unnamed function parameters, for example). Another benefit is IMO making testing easier: the API and persistence layers are not using them, and it's a lot harder to mock them, I had to resort to type erasure when building mocks (e.g. ` return Just(superheroes as! T)` in `SuperheroPersisterFixture`) There's an interesting talk on them by [Rob Napier](https://www.dotconferences.com/2016/01/rob-napier-beyond-crusty-real-world-protocols) from a few years ago, and a few episodes of [PointFree](https://www.pointfree.co/collections/protocol-witnesses).

#### Code comments
I tend not to like code comments, as they usually mean some logic is overly complicated and could be either broken down into smaller parts or rewritten altogether. However, there are some exceptions, like dealing with an external API and having to explain its behavior. For example, considering HealthKit, one might introduce a layer to simplify it or to make it more generic, and in these cases I've found code comments to be of great help. We can change our code to make it clearer, so less need for a comment, but we cannot change what we receive from our dependencies, so more need for explanations.

#### Git strategy
This project has been developed in something that might resemble git-flow, however I do think there are improvements to it that can be made. In my experience long-lived feature branches tend to eventually become a nightmare to merge back due to conflicts, and continuously merging from the main branch pollutes the branch history. Hence, I prefer to merge small and often, even if that means merging incomplete features. This strategy definitely makes it easier for the owner of the changes to be faster, and with less overhead, and at the same time the reviewer's job is eased by smaller PRs. There are, however, downsides to this, like having to hide incomplete code behind feature switches and the possibility of having it linger theoretically forever as the work might be forgotten or deprioritized. I've especially noticed the latter, but I do think that at the end of the day it might be a smaller price to pay compared to the alternatives.

I also tend to push many working commits for a specific branch/PR. While it might make the PR page longer to read, it helps a lot with being able to revert to previous changes or drop some. And in addition to that, I prefer to squash the changes on a PR, so that the tree history remains clean (and in any case the PR history is kept in the commit description).

## Miscellaneous
1. I've chosen to have a single global enum that holds most colors. It would have probably better suited to be hosted in the `EnvironmentObject`, but I've not had time to delve into it yet. It would also make it possible for the colors to be dynamic, so to support a design system and light and dark mode. I also think stuff like colors, and static dependencies, are a good use case for singletons — assuming there's little to none state, and it cannot be changed by the clients.
2. The app does not support localization, as every string is hardcoded. Having a helper method to locate the appropriate string from language-specific string files would be a nice addition.
3. Error states are not handles. However the infrastructure is already there (the view model's statuses) and it should be relatively trivial to show error messages, and retry affordances (triggering `.loading` again).
4. The alert on the destructive action of removing a superhero from the user's squad is missing. I do have implemented it based on the unidirectional data flow principles, but unfortunately SwiftUI does not support yet triggering closures when tapping buttons on an alert. I hope this will come in future releases as being forced to pass in a `Binding` is not exactly ideal and mixes responsibility principles.

## External libraries
This project uses the Swift Package Manager to import third-party dependencies. I've found the SPM to be pretty easy to use, despite some quirks and limitations.

On to the libraries.

#### Then
A micro-library that helps a lot with unidirectional data flow. It solves the problem of having to change just one (or a few) properties in an object but not wanting to manually re-populate the entirety of the fields. This is especially useful when returning a new state, based on the previous one and an event, in the reducers.

There was no strict need to import this, I'm just using one function, but I like to sort of "give back" by not importing the code directly.

#### Disk
While networking, or at least what it's needed for this kind of project, is relatively simple to write manually, I cannot say the same for writing to disk, as it is full of gotchas and edge cases. While this demo has quite a few units and snapshot tests for its core logic, I do not believe writing unit tests for the low-level intricacies of persisting to disk is a good use of time for the scope of the project. Hence, I've decided to use `Disk` to simplify this. In any case the persistence layer is abstracted by the various `DataProvider`s, so if need be we can move to different libraries.

#### SnapshotTesting
[PointFree](https://github.com/pointfreeco/swift-snapshot-testing)'s snapshot testing library. I use it because it's simple and yet powerful enough for my needs. It currently does not support SwiftUI but it was quite simple to add that capability (see `SnapshotTesting+SwiftUI`)

## What is missing and TODOs
#### Tests
Currently, `Remote` is not being tested. This is due to time constraints and to the fact that I've not yet delved into mocking `URLSession` for Combine.

UI tests are missing, too, due to time constraints. To be honest I have never set up UI tests infrastructure from scratch — it might take long, or not, I do not know. I've had experience in adding new tests similar to pre-existing ones and modifying others, but not yet setting them up. I would love to learn how to do it, but in fairness to the constraints of the project (I can't take too much time to solve it!) I've decided to skip them.

Everything else should be tested, unless I've accidentally missed it. There's also an integration test for the persistence layer, which probably belongs to another target (it's fast, though, so it's fine for now).

#### Pagination
Sadly I was not able to complete pagination (or fetching more than the initial 20 characters) in time. However, adding it is not a herculean task to this structure. What is needed:

* Add a view model UI event for it that is triggered once the displayed cell in SuperheroList is the last one
* Either add a new status (`.fetchingNext`) to the ViewModel, or re-use `.loading`
* Add a feedback that fetches the next `x` superheroes based on the current count
* Adapt the API to accept a parameter of `offset` with the number of new heroes to fetch
* Adapt the persister to write to disk the entirety of the superheroes array
* Display the new array in the view

TODO
## TODOs
* odd spacing issues (added by the scrollview?)
* shadows
* fix hero detail button width in bigger phones — probable SwiftUI bug
* fix hero detail hero name leading
* fix navigation color in hero detail
* add white margin to last appearances image
* add scrollview to detail view
* extract asyncimageview initialization into container views via a closure (similar to presented views)


# Bugs
* status bar should be color-able
* the divider just below the marvel logo does not go edge to edge
* images in mysquad disappear after returning from the detail view
* detail view often flashes because of the image being reloaded
