---
layout: single
title: "Bridging Callbacks and Async/Await"
date: 2020-09-23 12:00:00 -0000
categories: javascript async
excerpt: How to use async/await with legacy functions.
---

I imagine you will have some exposure to asynchronous logic in Javascript. A brief history: originally, JS only had callbacks, then they also implemented promises, and more recently we have seen async/await. However, you may still stumble upon old functionality that only allows callbacks.

How, then, can we adapt a callback-based function to use async/await? Well, we will have to respect the entire history of Javascript asynchronicity. For example, the JS FileReader object has to wait for an onload event:

```javascript
const reader = new FileReader()

reader.onload = (fileEvent) => {
  const fileContents = fileEvent.target.result
}
reader.onerror = () => {
  console.log('oops, something went wrong with the file reader.')
}
reader.readAsArrayBuffer(myFile)
```

You declare what the onload function will look like, then you actually call the FileReader on a file. What if you want to encapsulate this logic into its own function, and return the contents of the file? For example, maybe you want to pre-process the contents, and return the processed contents. The simplest way (conceptually) is to use a callback.

```javascript
const processFile = (file, callback) => {
  const reader = new FileReader()

  reader.onload = (fileEvent) => {
    const fileContents = fileEvent.target.result
    const processedContents = performPreprocessingOnFile(fileContents)
    callback(processedContents)
  }
  reader.onerror = () => {
    console.log('oops, something went wrong with the file reader.')
  }
  reader.readAsArrayBuffer(file)
}

const fileCallback = (processedContents) => {
  fetch('https://my-backend-site/post-endopint', {
    method: 'POST',
    body: processedContents,
  })
}

processFile(myFile, fileCallback)
```

Now you can use the processed contents, but you need to define a callback. Callbacks are pretty ancient, and have been dropped for a reason. They make code flow unintuitive, and you can descend into callback hell. Ideally, we would implement this with [promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/Promise). However, promises seems a bit intimidating to actually create! All that `resolve`, `reject` stuff seems a bit confusing. Fortunately, it is easier than it looks.

When creating a promise, the only thing you need is the `resolve` - this is what you would normally return. The `reject` is optional, but useful.

```javascript
const processFile = (file) => {
  const reader = new FileReader()

  return new Promise((resolve, reject) => {
  
    reader.onload = (fileEvent) => {
      const fileContents = fileEvent.target.result
      const processedContents = performPreprocessingOnFile(fileContents)
      resolve(processedContents)
    }
    reader.onerror = () => {
      reject('oops, something went wrong with the file reader.')
    }
    reader.readAsArrayBuffer(file)
  })
}

processFile(myFile).then((processedContents) => {
  fetch('https://my-backend-site/post-endopint', {
    method: 'POST',
    body: processedContents,
  })
})
```

This gives us the cleaner, promise-based syntax. Note that we could return the `fetch` call (which is a promise), and continue the chain without descending into callback hell. 

Finally, async/await is intended to work directly with promises. We still need to _return_ a promise in the first function, but our remaining lines can be abbreviated into this:

```javascript
const processedContents = await processFile(myFile)
fetch('https://my-backend-site/post-endopint', {
  method: 'POST',
  body: processedContents,
})
```

Note how relatively clean this is. There is no nesting of curly braces. If you want to catch the error, put the whole thing in a try/catch.

This is especially convenient, because async/await can handle some things that promises cannot. For example, let's say we modify our `processFile` function to include a check for the size of the file, and return null if it is too small.

```javascript
const processFile = (file) => {
  if (file.size > 1000) return null

  // everything else 
  const reader = new FileReader()
  return new Promise((resolve, reject) => {
    ...
```

If we continue to use the `then` syntax for our handling, it will throw an error. If you try to call `.then(` on a returned promise, it will succeed. However, calling `.then(` on a return of `null` will fail.

On the other hand, async/await will not care at all! It can handle either value. `await processFile(myFile)` will return either `null` or `processedContents`: it will automatically simplify the promise. Of course, this __is not always a good idea__, so implement at your own risk. If you are curious about this, just type these into your browser and look at the values:

```javascript
await 2 + 2
await fetch('google.com')
fetch('google.com')
```

Any time you need to connect your async/await based code to something older (or maybe more complicated, like event handlers), look no further than right here.