# Plum-interview-demo
A solution for Plum's iOS take-home test in SwiftUI and Combine




### Technical explanations
#### Stubs, SwiftUI Previews, and #if DEBUGs

There are a lot of `if #DEBUG`s scattered in the code. They mainly serve the purpose of providing stub data (fixtures) for tests and SwiftUI Previews. Ideally, these should not live in the same target as the "live" code, but instead be stored in the unit tests target. However, due to SwiftUI Previews not following this principle, we cannot really do that for now — hence, they being declared right next to the object.

#### Tests next to (actually, inside!) the features
Unit and snapshot tests are located in the same folder as to features. There's a good [explanation by Brandon Williams](https://kickstarter.engineering/why-you-should-co-locate-your-xcode-tests-c69f79211411?gi=fe48007b43d0) as to why this is useful. For me, it's just a matter of practicality — as the codebase grows, we tend to develop and stay on single feature for longer times, so it becomes increasingly harder to look for related files in different places. Tests still belong to different targets, however.

For bigger codebases, there's an argument to be made to create a separate target to make the engineer able to run snapshot tests independently from unit. They run fast in this demo app, so I've found no need to do so at the moment.

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