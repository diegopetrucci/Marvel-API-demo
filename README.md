# Plum-interview-demo

## General overview
A solution for Plum's iOS take-home test in SwiftUI and Combine.

The architecture is MVVM, which I've found to fit quite nicely with the way SwiftUI works. Moreover, it follows the unidirectional data flows principles to make sure changes are always safe to perform and easy to understand. I've been using redux at work and in personal projects and I've found it to be very adaptable to most scenarios. It's not perfect, but these state machines definitely help with most problems derived from handling state. In particular, it becomes really easy to avoid impossible states, something that plagues even Apple's own APIs (e.g being able to, theoretically, receive a `nil` `Data`, a status response with code `200 OK`, and an error from a network request). This kind of finite state machines and redux-like approach definitely make the codebase scream for a reactive approach to data/events management and a tree rendering for UI, but I believe it would be interesting to see them in a plain UIKit situation too. Maybe a thought for another exercise.

UI-wise, I've had to fight _a lot_ with SwiftUI. It is miles ahead of UIKit for semplicity and ease of use, and yes it does feel natural, but it also has severe limitations. I'm sure a lot of them will go away, but as it kind of happened with Swift, we will learn to either work around them or drop them completely in favour of new paradigms and patterns. I don't have much experience with Objective-C, but the way Swift literally does not permit you to perform "impossible" actions really reminds me of some SwiftUI quirks.  

The experiment has been fun, but I would advise in not using SwiftUI yet for production projects. Maybe rewriting a settings screens, or a debug tool so as to get familiarity with it, but not much. I do hope for WWDC to radically change this, but even then, we would be thinking of at least September-October for the changes to be stable and available, and realistically early/mid next year for something _safe_.

### Pull Requests and how to go through the code
The code is organized via a number of smaller PRs, to be read sequentially. I've chosen to do so to make the reviewer's life easier: as much as I trust my code it inerently shows my biases, even when tests are added, and so I _need_ other people to review it thourougly and check that it is, at least in theory, correct. Also, what might make sense in my head might not to other people, so this prevents domain or context black holes.

Smaller PRs for me mean less code to be evaluated, and even better if they only pertain a specific domain — for example, some UI changes or a backend model. This, however, increases the possiblity of the reviewer losing sense of the big picture. In my experience this is not a big problem if the app's architecture is standardized, or close to, but in case it's not it would be very helpful to have a chat about the architecture first, and when implemented, a catchup overview to fill in possible holes in the reviewer's context. Obviously this all depends on the size of the change, a 300 lines change is not the same as this project, where concepts like reactive programming and state machines might be introduced.

Another note on the PRs: I've gone with UI first instead of setting up the infrastructure (FSMs, networking, persistence, etc) immediately. For this particular project it's mostly because I did not want to pollute the PRs too much, but in general I quite like to go UI first as it forces me to think about what the views need, and not more than that — if the actual backend response contains more information, well, the view models have to strip it and map it. This is obviously truer for bigger responses that are not necesseraly geared towards UI, but if there is a backend-for-fronted-like middleware between the two this tends to be less applicable.  


## Technical explanations

#### Networking
Networking should be pretty much self-explanatory. It is set up to be as light as possible, with the usual protocol-first approach. `Remote` takes care of the `URLSession` API, errors, and decoding the result — all very coincise thanks to Combine.

Downloading images, too, is done in a native way, and it uses a little helper wrapper `AsyncImage` to fetch the image upon request. It does not support cancelling, but that can be added in a future revision.

I have not added support to automatic retrying if the network is unreachable, but it shouln't be a massive effort due to the nature of the architecture.

#### Persistance
While networking is pretty much "clean", as in it does not introduce external libraries, I've chosen to do it for persistance to disk. I use the aptly named `Disk` library, and not Realm, just because I wanted the lightest possible dependency while still being able to avoid the many edge cases of persisting data to disk.

Speaking of Realm, I am not sure if the API is still the same, but I tried it when I was learning iOS development and it was forcing upon the client to use `class`es instead of `struct`s. Various problems with, one, mutating the same object from different places, and two, trying to read the same object from different threads have burned into my soul the importance of value types and the avoidance of race conditions. I did not really what those terms meant at the time, but I intuitevely got the pain associated with them. :)

#### State machines and unidirectional data flow
I've already briefly touched on this in the intro, but it might be worth a few more words.

State machines to me are one of those ideas that after being exposed to them they kind of make you go like "wow, how did I live before this". Maybe it's due to not having had a computer science background, so the term and the ideas were new to me until they got introduced in my previous codebase. I enjoy a lot being able to craft a state in such a way that changes can happen only so far as to make _correct_ states, making incorrect one impossibles to reach (bugs aside…). Apple does _some_ of this in its code examples when it uses enums to represent view states, but more can be done.

Unidirectional data flow, too, is really nice to work with. Just like state machines it feel incredibly restrictive at first, but that goes away with experience. Having only one place where state can be changed, the View Model, means containing a good variety of bugs that would have happened otherwise.

SwiftUI generally works well with these two, but it does break down when having to switch over enums and working with optionals. However support for both is coming soon, so the ugly workarounds that I had to implement for them to work are luckly getting deprecated shortly.

Regarding the concrete implementation of the FSMs and UDF, I have borrowed Vadym Bulavin's implementation, which while not extensive is good enough for a project this size. The PointFree guys have done some very good work on theirs, too, and it's interesting how they've decided to go with a single composable store (I do however wonder if it scales well with bigger apps, it would be nice to test it).  

#### Stubs, SwiftUI Previews, and #if DEBUGs
There are a lot of `if #DEBUG`s scattered in the code. They mainly serve the purpose of providing stub data (fixtures) for tests and SwiftUI Previews. Ideally, these should not live in the same target as the "live" code, but instead be stored in the unit tests target. However, due to SwiftUI Previews not following this principle, we cannot really do that for now — hence, they being declared right next to the object.

#### Tests next to (actually, inside!) the features
Unit and snapshot tests are located in the same folder as to features. There's a good [explanation by Brandon Williams](https://kickstarter.engineering/why-you-should-co-locate-your-xcode-tests-c69f79211411?gi=fe48007b43d0) as to why this is useful. For me, it's just a matter of practicality — as the codebase grows, we tend to develop and stay on single feature for longer times, so it becomes increasingly harder to look for related files in different places. Tests still belong to different targets, however.

For bigger codebases, there's an argument to be made to create a separate target to make the engineer able to run snapshot tests independently from unit. They run fast in this demo app, so I've found no need to do so at the moment.

#### Code comments
I tend not to like code comments, as they usually mean some logic is overly complicated and could be either broken down into smaller parts or rewritten altoghether. However, there are some exceptions, like dealing with an external API and having to explain its behaviour. For example, considering HealthKit, one might introduce a layer to simplify it or to make it more generic, and in these case I've found code comments to be of great help. We can change our code to make it clearer, so less need of a comment, but we cannot change what we receive from our dependencies, so more need for explanations.

#### Git strategy
This project has been developed in something that might resemble git-flow, however I do think there are improvements to it that can be made. In my experience long-lived feature branches tend to eventually become a nightmare to merge back due to conflicts, and continuously merging from the main branch pollutes the branch history. Hence, I prefer to merge small and often, even if that means merging incomplete features. This strategy definitely makes it easier for the owner of the changes to be faster, and with less overhead, and at the same time the reviewer's job is eased by smaller PRs. There are, however, downsides to this, like having to hide incomplete code behind feature switches and the possibility of having it linger theoretically forever as the work might be forgotten or deprioritised. I've especially noticed the latter, but I do think that at the end of the day it might be a smaller price to pay compared to the alternatives.

I also tend to push many working commits for a specific branch/PR. While it might make the PR page longer to read, it helps a lot with being able to revert to previous changes or drop some. And in addition to that, I prefer to squash the changes on a PR, so that the tree history remains clean (and in any case the PR history is kept in the commit description).

## What is missing
#### Tests
Currently, `Remote` is not being tested. This is due to time constraints and to the fact that I've not yet delved into mocking `URLSession` for Combine.

UI tests are missing, too, due to time constraints. To be honest I have never set up UI tests infrastructure from scratch — it might take long, or not, I do not know. I've had experience in adding new tests similar to pre-existing ones and modifiying others, but not yet setting them up. I would love to learn how to do it, but in fairness to the constraints of the project (I can't take too much time to solve it!) I've decided to skip them.

## To explain
* no localization

## TODO
* move swift preview assets to that folder
* extract default spacing 16 to constant
* extract background color into environment
* odd spacing issues (added by the scrollview?)
* highlighted states (buttons, cells, etc.)
* shadows
* /255 colors
* fix hero detail button width in bigger phones
* fix hero detail hero name leading 
* fix navigation color in hero detail
* add white margin to last appearances image
* add scrollview to detail view
* automatic retrying of failed calls?

# Bugs
* navigation bar should be color-able
* the divider just below the marvel logo does not go edge to edge
* navigation link pushes twice https://stackoverflow.com/questions/57946197/navigationlink-on-swiftui-pushes-view-twice