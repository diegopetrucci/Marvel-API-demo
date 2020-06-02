# Plum-interview-demo

## General overview
A solution for Plum's iOS take-home test in SwiftUI and Combine.

The architecture is MVVM, which I've found to fit quite nicely with the way SwiftUI works. Moreover, it follows the unidirectional data flows principles to make sure changes are always safe to perform and easy to understand. I've been using redux at work and in personal projects and I've found it to be very adaptable to most scenarios. It's not perfect, but these state machines definitely help with most problems derived from handling state. In particular, it becomes really easy to avoid impossible states, something that plagues even Apple's own APIs (e.g being able to, theoretically, receive a `nil` `Data`, a status response with code `200 OK`, and an error from a network request). This kind of finite state machines and redux-like approach definitely make the codebase scream for a reactive approach to data/events management and a tree rendering for UI, but I believe it would be interesting to see them in a plain UIKit situation too. Maybe a thought for another exercise.

UI-wise, I've had to fight _a lot_ with SwiftUI. It is miles ahead of UIKit for semplicity and ease of use, and yes it does feel natural, but it also has severe limitations. I'm sure a lot of them will go away, but as it kind of happened with Swift, we will learn to either work around them or drop them completely in favour of new paradigms and patterns. I don't have much experience with Objective-C, but the way Swift literally does not permit you to perform "impossible" actions really reminds me of some SwiftUI quirks.  

The experiment has been fun, but I would advise in not using SwiftUI yet for production projects. Maybe rewriting a settings screens, or a debug tool so as to get familiarity with it, but not much. I do hope for WWDC to radically change this, but even then, we would be thinking of at least September-October for the changes to be stable and available, and realistically early/mid next year for something _safe_.

### Pull Requests and how to go through the code
The code is organized via a number of smaller PRs, to be read sequentially. I've chosen to do so to make the reviewer's life easier: as much as I trust my code it inerently shows my biases, even when tests are added, and so I _need_ other people to review it thourougly and check that it is, at least in theory, correct. Also, what might make sense in my head might not to other people, so this prevents domain or context black holes.

Smaller PRs for me mean less code to be evaluated, and even better if they only pertain a specific domain — for example, some UI changes or a backend model. This, however, increases the possiblity of the reviewer losing sense of the big picture. In my experience this is not a big problem if the app's architecture is standardized, or close to, but in case it's not it would be very helpful to have a chat about the architecture first, and when implemented, a catchup overview to fill in possible holes in the reviewer's context. Obviously this all depends on the size of the change, a 300 lines change is not the same as this project, where concepts like reactive programming and state machines might be introduced.


## Technical explanations
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

# To explain
* no localization

# TODO
* move swift preview assets to that folder
* extract default spacing 16 to constant
* extract background color into environment
* odd spacing issues (added by the scrollview?)

# Bugs
* navigation bar should be color-able
* the divider just below the marvel logo does not go edge to edge