+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Old Man Yelling at the Corpus"
date = "2026-05-10"
[taxonomies]
tags = ["language", "documentation", "ai", "llm"]
+++

> *Rules provide system-level instructions to Agent*.<br />
> ---[Cursor docs, "Rules"](https://cursor.com/docs/rules)

I keep getting stuck on that sentence. Not because of the missing article
(though, *yes*, **to "the" Agent** is what **English** wants here), but 
because of what the missing article tells us about the prose underneath: 

The whole document reads like a config schema that someone half-translated 
into English and then shipped.

Cursor is influential enough that...

* its documentation will be read at scale,
* copied into prompts, 
* embedded into internal docs, 
* and eventually scraped back into the next training corpus. 

Whatever conventions ship from there **propagate**. 

So when I land on a sentence like that one, I am not really annoyed at Cursor. 

**I am noticing a pattern**. And, I'm nothing if I'm not good at pattern 
recognition.

## The Schema-text Reflex

The sentence reads like a function signature:

```text
Rules -> provide(system_level_instructions, Agent)
```

That is *fine* for an internal model of an API.
It is **blasphemy** for English.

English needs the connective tissue:

> **Rules provide system-level instructions to the Agent.**

Or, if "*Agent*" is not a named product persona but a generic role:

> **Rules provide system-level instructions to an agent.**

Or, more natural:

> **Rules define the system-level instructions that guide the Agent's behavior.**

* Three different propositions, 
* none of them equivalent, 
* all cheaper to **read** than the bare-bones original. 

The articles are **NOT** decoration. 

They are saying:

**this** Agent (*you know, the one we both already know about, the one the 
rest of this  document is --in fact-- about*) 

Drop the article and Agent floats between a proper noun, type identifier, and 
abstract role. 

The reader has to disambiguate at every reference. That's **costly**.

## The Model of the World

Sharper version of the same point. Compare the three:

* "*Configure policy for runtime.*"
* "*Configure the policy for the runtime.*"
* "*Configure a policy that applies at runtime.*"

Same content words: Three different propositions. 

The first sounds like a CLI flag description. 

The second presupposes specific known entities (*the* policy,
*the* runtime) that both reader and writer have in mind. 

The third describes a kind of action with a **scope condition**. 

Whatever you say about token efficiency or prose density, those three sentences 
are **not interchangeable**, and the words doing the discriminating are 
**exactly** the ones the compression instinct wants to delete.

In linguistics, function words (*articles, prepositions, auxiliaries,
determiners*) are the **operators** in a sentence.
Whereas, content words are the **operands**.

In ["*agrammatic aphasia*"][aphasia], the damage is often not that the speaker 
has no nouns. It is that the grammar-binding machinery (articles, 
auxiliaries, prepositions, inflection...) is impaired. 

The **connective tissue** is not ornamental; it is **structural**.

[aphasia]: https://pubmed.ncbi.nlm.nih.gov/31199471/

So when I read "*Rules provide system-level instructions to Agent*", I am not
reading a sentence that has been gently streamlined: I am reading a sentence
whose model-of-the-world has been **partially evacuated**. 

**The missing words are where the model of the world lives.**

## Block Language Escapes Its Register

There is a name for this register. 

Linguists describe it under various labels; 
[David Crystal's dictionary][crystal] gives 
one canonical version: **block language**: 

[crystal]: https://www.davidcrystal.com/Files/BooksAndArticles/-4887.pdf

The compressed form of telegrams, headlines, recipes, road signs, captions: 

* Man bites dog. 
* Add flour to bowl. 
* Do not enter. 

Block language was always a *register*: a deliberately reduced form for a 
constrained channel: 

* Column inches. 
* Signboard real estate. 
* Telegraph cost-per-word. 

The **constraint** was the whole point. 

Nobody wrote contracts that way. Nobody wrote novels that way. 

You **did not** get block language in a tutorial, because the tutorial channel 
was not constrained.

What is happening now is that block language has **escaped its register**. 

The constraint that produced it is gone:

* context windows are vast, 
* models output thousands of tokens at trivial cost 

**BUT** the **style** persists, because it scored well during **training** on a 
corpus where headline-ese and prose both appeared and the **loss function** 
could not tell them apart. 

So we get block language in places where it does not belong:

* README files. 
* API docs. 
* Tutorials. 
* Internal memos.

That's documentation written in the register of a road sign.

The result is what I keep mentally calling **product-doc pidgin**: 

Weirdly efficient, **spiritually dead**. 

*Users can configure rules to improve agent behavior across workflows.* 

You can feel the wax dummy.

**There is no person in there**.

## That's Devolution

I do understand that language is a living, breathing, evolving entity.

But "*this*" (*whatever this is*) is not language evolving:
It is language being compressed and compromised.

I know how this sounds: **Old man yells at the corpus.**

Yes:

* Languages drift. 
* Articles get shed. 
* Prepositions wander off. 

English itself dropped enough Old English inflection to embarrass a modern 
German. 

Who am I to defend "to **the** Agent"?

But... not like this.

The thing is: drift is fine. 

Drift is what living languages do. 

Drift is humans selecting, **over time**, for what communicates well, what 
feels right in the mouth, what signals belonging to a tribe. 

There is a **body** in that loop: 

* a mouth, 
* an ear, 
* a tribe, 
* a risk,
* a joke, 
* a need...

Even something as algorithmically warped as TikTok-speak 
(*"unalive," "the algorithm doesn't want me to say this"*) is at
least human-driven attention compression. 

There is a person at the keyboard, optimizing for a goal a person has.

What is happening to product documentation is **not** that. 

It is **corpus-mediated flattening**. 

The selection pressure is not "*did this communicate*", but "*did this
score well under a fluency model*". 

The output gets reified into a (quote) "*professional documentation style*" 
that humans then imitate back, often via the same models.

The loop is **recursive**, and there is **no body** in it. 

The optimization target, and the reward function converge onto:

* plausibility,
* brevity,
* and pattern survival.

I'm sorry, and **this is not communication**.

Heck, this is not even "*prose*".

I would not be writing this if the volume were small. 

The volume is large and growing. 

The default register of professional technical writing is shifting
under our feet, and the shift is being driven by a process that does not
actually care about prose.

## Not Prescriptivism

The honest counter is that prescriptivism has a bad track record. 

"*Good prose*" complaints calcify into class signaling and gatekeeping. 

Style guides get used as cudgels against people who code well but write 
functionally, against non-native speakers, against anyone whose English does 
not match the editor's. 

I am sympathetic to all of that. I---myself---am a non-native English speaker.

I am "*way more expressive, and way more intelligent*" in Turkish, than I am
in English.

So, this definitely is not that.

I am not policing dialect or accent or non-native phrasing.

What I am saying is that a global-scale, self-reinforcing, non-human, inhumane,
optimization process is **flattening** a feature of the language that does
critical semantic work.


The people best positioned to notice (*editors, technical writers, attentive 
readers---neurodivergents, too*) are the people whose noticing has been least 
incentivized for the last decade: 

* Editors got **optimized out** (hint: "*laid off*") of most documentation 
  pipelines. 
* Technical writers got reframed as a *cost center*. 
* Readers walk away from bad docs vaguely unsatisfied and blame themselves
  for not getting it.

## Tilting at Giants

I thought for a second "*am I the Don Quixote here?!*"

Yet, the "*Don Quixote*" frame is tempting, albeit wrong. 

Quixote was tilting at windmills he believed were giants. 

**This is the inverse**:

Tilting at giants that everyone insists are windmills. 

The damage is real; what makes it hard to defend against is exactly that 
each instance is small, and the aggregate is invisible to the
optimization process producing it. 

No single sentence is a tragedy: **The trajectory is**.

So: *"Rules provide system-level instructions to Agent"* is not a typo. 

It is a **genre marker**. 

The genre is **prose written by a system that does not know it is
writing prose**. 

The fix is not just "*add the article*": It is to **remember**
that the article was doing the work, and that the work was **real**.

I would like product documentation, especially documentation that millions of
developers read, to **remember** that too.

If not clear, I'm looking at you Cursor!
