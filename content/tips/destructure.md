+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Use Destructuring to Remove Attributes "
date = "2023-03-07"

[taxonomies]
tags = ["development","tips"]
+++

{{img(
  src="/images/size/w1200/2024/03/destructure.png",
  alt="Destructure."
)}}

Here's a neat little trick:

In JavaScript, you can destructure unwanted/sensitive attributes from an object.

Here's an example:

```javascript
const user = {
  firstName: "Matara",
  lastName: "Masuko",
  ssn: "123-45-6789",
  location: "USA"
};

const { ssn, ...cleanUser } = user;

console.log(cleanUser);
// logs: { firstName: 'Matara', 
//   lastName: 'Masuko', location: 'USA' }
```

It's much cleaner than looping through all attributes, eh?

That was your little nugget.

Until next time... May the source be with you 🦄.

--------

## Section Contents

{{ tips_nav(selected=2) }}
