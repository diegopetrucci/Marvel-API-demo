# Plum-interview-demo
A solution for Plum's iOS take-home test in SwiftUI and Combine




### Technical explanations
#### Stubs, SwiftUI Previews, and #if DEBUGs

There are a lot of `if #DEBUG`s scattered in the code. They mainly serve the purpose of providing stub data (fixtures) for tests and SwiftUI Previews. Ideally, these should not live in the same target as the "live" code, but instead be stored in the unit tests target. However, due to SwiftUI Previews not following this principle, we cannot really do that for now — hence, they being declared right next to the object.

# To explain
* 


# Bugs
* navigation bar should be color-able
* the divider just below the marvel logo does not go edge to edge