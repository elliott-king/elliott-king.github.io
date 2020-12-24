---
layout: single
title: "When to use UseEffect"
date: 2020-12-02 09:00:00 -0000
categories: javascript react
---

`useEffect` is for side effects.

Although the new hooks are considered "functional React," they still follow Object-Oriented Programming methodologies. For example, `useState` maps to the pre-existing `this.state` of the older class components. State was a pretty easy concept to understand. Much like a class instance has its own variables (commonly accessed in JS with `this`), a React component has its own state. 

Following Object-Oriented programming paradigms, you will have functions that affect outside classes. This is similar, conceptually, to `useEffect`. 

When would we want to trigger some sort of side effect? Well, there are three general cases:
- when the component is first created
- whenever the component is re-rendered
- when the component is destroyed
- when the state changes (or part of the state)

Each of these changes how `useEffect` is called. Remember that the hook accepts two arguments:

```javascript
useEffect(callback[, dependencies]);
```

### Only when the component is first created

If you pass in an empty array, `useEffect()` will be called only on the initial component creation (like `componentDidMount` for the class component). For example, if we wanted to make a request on creation, and fill the state, it would look something like this:

```javascript
const [contents, setContents] = useState([])

useEffect(() => {
  fetch(url)
    .then(res => res.json())
    .then(json => setContents(json))
}, [])
```

This will populate the component, but only when it is first created.

### Whenever the component is re-rendered

If we want the `useEffect` contents to run on every render, you should only pass in a callback, with no dependencies. For example, if a user is composing a message, you could send a copy of the draft to the server, so it does not get lost.

```javascript
const [draft, updateDraft] = useState('')

useEffect(() => {
  fetch(url, {
    method: 'POST',
    body: draft,
  })
})
```

Note that there is no second argument in this case.

### When the component is destroyed

Sometimes, when you set something up on component creation, you want to remove it after destruction. For example, you may want to update a Redux variable or close a websocket upon deletion of the component. This has little to do with the second argument of the function. Instead, you return a cleanup function in the callback. *Note* that this will run on every re-render, prior to the re-render.

```javascript
useEffect(() => {
  /* do something */
  const cleanup = () => {
    /* delete something */
  }
  return cleanup
})
```

For example, if you want to create a continuous function that logs to console every few seconds, you should delete it when the component is deleted:

```javascript
useEffect(() => {
  const id = setInterval(() => {
    console.log("This is logged to console.");
  }, 5000);
  const cleanup = () => clearInterval(id)
  return cleanup
}, []);
```

### When the state changes

This is probably the most common use, besides when the component mounts. If you want to create a side effect that is based on the state, you pass in one or more pieces of state (or props) that you care about.

```javascript
const ToyReactComponent = (props) => {
  const [internalState, changeInternalState] = useState("")

  useEffect(() => {
    console.log("Something was updated!")
    console.log(internalState, props.somePropValue)
  }, [internalState, props.somePropValue])
}

If any variable is used in `useEffect`, it should almost **ALWAYS** be in the dependency list.