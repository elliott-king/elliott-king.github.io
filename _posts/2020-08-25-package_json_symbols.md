---
layout: single
title: "The Symbols In Your package.json File"
date: 2020-08-25 12:00:00 -0000
categories: nodejs javascript package-json
description: An explanation of the random symbols you will find in your package.json file.
---
I have often been confused by the symbols in the package.json file. If you are new to node.js, and you create a new app with `create-react-app` or some other framework, it generates a package.json file for you. I have always felt that most of the file is very clear, even if you are a newbie. "Name," "version," "dependencies," and "scripts," are all very clear descriptors. However, there are often symbols thrown around in the package dependencies, and it is not always clear what they mean.

## Symbols relating to package version
Most of these will relate to the __version__ of a given dependency package. Note that a version number is split into three values. These are called 'major,' 'minor,' and 'patch.' For example, if a package is at version 3.4.5, the major is 3, the minor is 4, and the patch is 5. The last number will change most frequently (for every tiny change), while the first number should only be changed if there is a serious code overhaul.

### equality
If there is no operator in front of the version number, this is assumed. However, you can still include `=` if you like. `=3.2.1` and `3.2.1` will both expect __exactly__ version 3.2.1.

### less than/greater than
You may see `<=`, `>`, etc, but these are rarely used. These follow basic logic. `>=3.2.1` would match 3.2.3, 3.4.7, and also 4.2.7. These are problematic, because they are too broad. Generally, you want to limit yourself to certain versions, to maintain operability. This takes us to the more common options:

### hyphen
You can use `-` between two versions, that you specify. This is useful if you need to maintain some legacy feature that you know will break at a specific version. For example, `1.3.2 - 2.4.1`. This will include __both endpoints__.

### X marks the spot
Any of `X`, `x`, or `*` may be used to “stand in” for one of the numeric values. I will take the example straight from the [semver](https://docs.npmjs.com/misc/semver) documentation:

- \* := >=0.0.0 (Any version satisfies)
- 1.x := >=1.0.0 <2.0.0 (Matching major version)
- 1.2.x := >=1.2.0 <1.3.0 (Matching major and minor versions)

### tilde
The `~` means "approximate version." This allows for more recent patches, but does not accept any packages with a different minor version. For example, `~2.3.3` will allow values between `2.3.3` and `2.4`, _not including 2.4_. Note that this will allow differences in the minor version is none is specified. `~2` will accept _any_ version that starts with 2.

### carat
The `^` means "compatible with version," and is more broad than the tilde. It only refuses changes to the _major_ version. For example, `^3.4.1` will allow any version between that value and `4.0.0`, _not including_ version 4. __Note__ that this behaves very differently for version numbers that start with zero, so be careful.

There is also a handy [versioning calculator tool](https://semver.npmjs.com/).

## Relating to package scope - the "at" sign
Some npm packages have a scope. Scopes are preceded by the "at" sign, for example `@testing-library/react`. The scope is "testing-library", the package name is "react." Only the organization that owns a scope can add packages to it, so you can be sure that you are using official code. A scoped package cannot be fetched just by using its name. In this example, this differentiates it from the official facebook react framework, while still having a clear name. In my package.json, I have:

```javascript
"@testing-library/react": "^9.3.2",
"react": "^16.13.1",
```

When you import them in a file, you will still import them with their full name, eg `import { render } from '@testing-library/react'`. Interestingly enough, they are also put in a subfolder in `node_modules/` depending on the scope.