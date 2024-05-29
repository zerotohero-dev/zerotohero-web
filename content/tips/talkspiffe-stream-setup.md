+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "The Live Stream Dream"
date = "2024-05-27"

[taxonomies]
tags = ["tips", "setups", "streaming"]
+++

{{img(
  src="/images/size/w1200/2024/03/stream.png",
  alt="Streaming."
)}}

## Introduction

It is an understatement to say that "_**streaming is complicated**._"

Live streaming, especially involving _multiple participants_, is an intricate
technology dance. Each puzzle must harmonize to ensure a seamless, interactive,
high-quality viewer experience.

The complexity increases even more when we decide to share not just our faces or
voices but our desktops too. This is the path we have chosen in [our ongoing 
**TalkSPIFFE** series](https://www.twitch.tv/VadidekiVolkan/schedule): The live
office hours we dedicate to the **SPIFFE** and **SPIRE** community.

This article provides a comprehensive guide for designing an intricate
multi-platform streaming model. I want this to be a resource for my future self
and the fantastic community interested in replicating such a setup. It's an
insider look into the dynamic and complex world of multi-streaming, showing how
technology, when used innovatively, can foster powerful and engaging digital
experiences.

{{img(
  src="/images/size/w1200/2023/06/Screenshot-2023-06-16-at-11.33.11-AM.png",
  alt="Eli (left) and I (right) enjoying the show."
)}}

## TalkSPIFFE? Is That Something New? Can I Eat It?

Before I continue, it's a perfect moment to delve deeper into what 
[**TalkSPIFFE**](https://twitch.tv/VadidekiVolkan) truly is.

**TalkSPIFFE** is more than just a live stream; it's a platform designed to
demystify and elucidate the intricacies of the 
[**SPIFFE**](https://spiffe.io/) (*Secure Production Identity Framework for 
Everyone*) technology. It's an opportunity for **SPIFFE/SPIRE** enthusiasts, 
professionals, and those who want to learn more about **SPIFFE** and **SPIRE** 
to come together and engage in enlightening discussions, learn from each other, 
and help foster a community.

We've aimed for **TalkSPIFFE** to be a space that feels both welcoming and
informative rather than being strictly academic or intimidatingly technical. We
believe in a more dynamic interaction that allows anyone and everyone to gain
knowledge and contribute unique insights.

In our weekly sessions every other Friday, we tackle various **SPIFFE**-related
topics, discuss the latest updates, share best practices, and do live demos.

Whether you're just dipping your toes into the **SPIFFE** waters or are a
seasoned professional looking to stay updated and share your wisdom,
**TalkSPIFFE** offers you a place to do just that.

So join us in our upcoming streams, and let's make **TalkSPIFFE** a thriving
platform for learning, sharing, and collaborative growth in **SPIFFE** and *
*SPIRE**.

That was the segue 🙂 Now, back to our setup.

## A Deep Dive Into the TalkSPIFFE Streaming Setup

Since my streaming setup is far from ordinary, I wanted to give you an inside
look into the process.

In this article, I'll share how we've used applications like 
[**Audio Hijack**](https://rogueamoeba.com/audiohijack/), 
[**Loopback**](https://rogueamoeba.com/loopback/), 
[**Airfoil Satellite**](https://rogueamoeba.com/airfoil/mac/), 
[**Farrago**](https://rogueamoeba.com/farrago/), 
**_Zoom_**, **_Discord_**, 
[Twitch's Guest Star feature](https://help.twitch.tv/s/article/guest-star?language=en_US), 
[**Open Broadcaster Software (_OBS_)**,](https://obsproject.com/) and 
[**BetterDisplay**](https://github.com/waydabber/BetterDisplay) to create a
compelling and interactive live streaming experience.

Each platform plays a vital role, from integrating our desktops through Zoom and
routing our audio via a Discord voice channel to broadcasting our video feed on
Twitch. The added twist of background music takes the viewer experience to
another level, immersing them in our conversational and instructional narrative.

## Twitch's Guest Star Feature is a Life Saver

Navigating the turbulent waters of streaming a guest's audio and video on a live
stream can be challenging. This is where [Twitch's innovative "**Guest Star**" feature](https://help.twitch.tv/s/article/guest-star)
shines.

The **Guest Star** tool lets you establish "guest slot" browser sources you can
deftly arrange in your broadcasting software. With ease, you can swiftly add or
change the guests appearing in that slot directly through **Twitch**.

The beauty of this feature is its **simplicity**: Streamlining the process of
integrating a guest's video feed into your live stream, and all without needing
to dabble with complex configurations or multiple third-party tools.

Using this feature, I can stream the camera of my guest directly as a browser
source into my Open Broadcaster Software (**OBS**).

If I want, I can also change the guests appearing in that slot directly through
Twitch, effortlessly integrating a guest's video feed into my live stream
without juggling complex configurations or multiple third-party tools.

So far, everything about **Guest Star** works like a charm.

## A Sneak Peek at the Backstage

Here's how we typically initiate our stream:

Before the event starts, there is a 15-minute interval where the stream will be
live and a "*starting soon*" scene with a countdown timer is displayed life
(_the `63:46` countdown timer in the image below is just for demonstration
purposes; consider it something like 11:25 or similar---starting from 15:00 and
counting backward_).

{{img(
  src="/images/size/w1200/2023/06/Screenshot-2023-06-15-at-2.30.25-PM.png",
  alt="The 'waiting room' and the countdown timer."
)}}

During that time, I invite [**Eli**](https://www.linkedin.com/in/elinesterov/),
**TalkSPIFFE**'s cohost, as a "[_guest star_](https://help.twitch.tv/s/article/guest-star?language=en_US)"
to a virtual backstage. That's how I can use his camera feed on the stream.

In addition, I initiate a Discord voice chat session from which we air Eli's
voice feed.

After I ensure the guests' camera and sound work fine, using the **Studio Mode**
of OBS, I make sure that all the scenes and camera feeds are up and running and
there is no missing source anywhere.

This step is significant because when you reboot your system or restart OBS,
sometimes OBS fails to detect some of the input sources, and you'll need to
update them manually.

{{img(
  src="/images/size/w1200/2023/06/Screenshot-2023-06-15-at-2.40.42-PM.png",
  alt="OBS's Studio mode. Left: Upcoming scene; right: the scene streaming live."
)}}

I use [**Audio Hijack**](https://rogueamoeba.com/audiohijack/) for chaining,
filtering, and mixing various audio streams. And I use 
[**Loopback**](https://rogueamoeba.com/loopback/) to create virtual audio interfaces that I
can set as audio input sources for Zoom and Discord. As you'll see shortly, the
loopback interfaces I make in Audio Hijack will find their respective places
as "*sinks*" in Audio Hijack.

## The **TalkSPIFFE** Audio Chain

Here follows our **Audio Hijack** stream setup. You can tap on the image to see
an enlarged version. I will zoom in and explain each box in this layout below:

{{img(
  src="/images/size/w1200/2023/06/audio-hijack.png",
  alt="The audio chain."
)}}

It might look a bit involved, though fear not; we'll dissect the entire audio
chain piece by piece.

Let's zoom into the topmost browser source first:

{{img(
  src="/images/size/w1200/2023/06/Screenshot-2023-06-13-at-1.39.25-PM.png",
  alt="Splitting the background music."
)}}

The input source named "**MUSIC IN**" is Safari playing a playlist of
instrumental music as background music for **TalkSPIFFE**. I split the audio
into three parts:

* The top row is adjusted to a lower volume level and is to be used as the
  background music when we talk,
* The middle row has a higher volume level, and it's to be played before the
  stream starts or during breaks,
* And the bottom one is a separate track that will be streamed to my and my
  guest Eli's headphones.

Then, there is an A/B switch (*see the image below*) where the top two rows 
meet:

{{img(
  src="/images/size/w1200/2023/06/Screenshot-2023-06-13-at-1.39.55-PM.png",
  alt="To the output device."
)}}

Then, there is an A/B switch (_see the image above_) where the top two rows meet
for me to toggle between two different volume levels and send the virtual output
devices named "**Stream Background Pass**" and "**Zoom Mic PassThru**,"
respectively.

These virtual devices are loopback audio interfaces that I created using 
[**Loopback**](https://rogueamoeba.com/loopback/).

* **Stream Background Pass** is used by OBS as a background music source for the
  stream,
* and **Zoom Mic PassThru** is sent to the Zoom video chat session that we share
  this stream simultaneously.

If you look closely, you'll see that the top set of volume filters is lower than
the bottom ones on the second row. This way, we can have quieter background
music to talk over during the stream without becoming too loud to distract the
audience. During breaks or before the stream begins, I can switch to the bottom
lane to let the audience enjoy the music to its fullest.

Then comes the third row. Follow the arrows in the image below:

{{img(
  src="/images/size/w1200/2023/06/Screenshot-2023-06-13-at-1.40.25-PM.png",
  alt="We also enjoy the background music while streaming."
)}}

The third row is what Eli and I hear in our headphones as a piece of background
music so that we can bob our heads to the same beats during the event 🙂.

Let's move on to our next audio source: Discord. Discord is where I capture
Eli's voice and forward it into two mixers.

You'll also see that "**_Guest Star_**" audio is forwarded to the same mixer. I
aim to use the "Guest Star" feature as a backup audio source. So, if anything
happens to Discord, I can disable Discord and swap it to Guest Star instead to
capture Eli's audio.

{{img(
  src="/images/size/w1200/2023/06/Screenshot-2023-06-13-at-1.40.58-PM.png",
  alt="Splitting the guest audio."
)}}

Or an alternative way is to use an A/B switch and keep both of the input sources
enabled and switch between them using the A/B switch:

{{img(
  src="/images/size/w1200/2023/06/Screenshot-2023-06-15-at-10.04.25-PM.png",
  alt="Using an A/B switch."
)}}

Then, in the middle of the setup, I have two audio sources:

* **ELI AUDIO IN** (*Discord*) is a Discord voice chat that Eli and I will use.
  I take Eli's audio from that source to push it into 
  [OBS (*Open Broadcast Software*)](https://obsproject.com/) as a stream source. 
  While at that, I'll also clone it and send it to my headphones through a separate channel.
* **GUEST STAR** (*Chrome*) is where
  Eli's [Twitch Guest Star](https://help.twitch.tv/s/article/guest-star?language=en_US)
  browser source is. I keep it as a backup source in case Discord's audio fails.
  Though I've had minor glitches while testing it as an audio source, I'm
  reluctant to use it. For now, it's just a backup for emergencies.

{{img(
  src="/images/size/w1000/2023/06/Screenshot-2023-06-13-at-1.42.00-PM.png",
  alt="Mixing the vocals."
)}}

The orange lines above pass through my microphone 
([**_Shure SM7B_**](https://www.shure.com/en-US/products/microphones/sm7b)), 
a general-purpose noise filter, a vocal-specialized noise filter, and an 
equalizer before it reaches an A/B switch, respectively.

I use the A/B switch to quickly prevent my voice from being sent to the stream.
That way, I can tell something Eli behind the scenes without my voice broadcast
live.

In the image below are my equalizer settings for the curious; this setup makes
more voice subtly deeper. Overdo it, and you'll sound like Darth Vader or an
accented version of Morgan Freeman. Be very careful.

{{img(
  src="/images/2023/06/Screenshot-2023-06-13-at-1.28.53-PM.png",
  alt="Equalizer settings."
)}}

Since everyone's audio gear, vocal cords, room, and vocal modulation needs
differ, your equalizer setting will likely vary significantly from mine. So, I'm
leaving this just as a reference point. Trust your ears and experiment with the
settings until you are satisfied.

Remember: Subtler is better. Be so subtle that the difference is almost
unnoticeable to an untrained ear. If you realize what you generate sounds
considerably different than you, then you have overdone it. And, trust me, it's
**very** easy to overdo with one's own vocals. When you set it up, take a
30-minute break, do something else, and then listen to your audio again. If it
sounds odd, you have overshot some settings; try readjusting it.

And below is my noise gate. Again, this is a representative snapshot and may not
meet your needs. Adjust the configuration yourself, and always use your ears.

{{img(
  src="/images/2023/06/Screenshot-2023-06-13-at-1.29.12-PM.png",
  alt="Noise gate settings."
)}}

The green line has the same setup except for the intermediate filtering. It's
the sound coming from our dear guest, Eli. I'm sharing the image below again for
your convenience:

{{img(
src="/images/size/w1000/2023/06/Screenshot-2023-06-13-at-1.42.00-PM.png",
alt="Mixing the vocals."
)}}

Then my voice and Eli's are combined, compressed, gain-adjusted, and set to 
"_**SPIFFE Loopback Audio**_" as a sink (_see below_)---_SPIFFE Loopback Audio_
is a virtual audio device.

{{img(
  src="/images/2023/06/Screenshot-2023-06-13-at-1.42.32-PM.png",
  alt="Onwards to the virtual audio device."
)}}

I created "**_SPIFFE Loopback Audio_**" using [**Loopback**](https://rogueamoeba.com/loopback/); 
I use it in OBS as an audio source to send to the stream.

{{img(
  src="/images/2023/06/Screenshot-2023-06-13-at-1.43.14-PM.png",
  alt="Combining with the background music."
)}}

Then the background music (*arrows coming from the top*) and our combined
vocals (*arrows coming from the bottom*) are mixed into a single stream and sent
to the "**Zoom Mic PassTru**" Loopback virtual device to be used as an audio
source in Zoom (*see below*).

{{img(
  src="/images/2023/06/Screenshot-2023-06-13-at-1.44.40-PM.png",
  alt="Mixing my vocals with the background music."
)}}


This final image above shows how my vocals are combined with the background
music and pushed toward the "**Volkan Just Mic**" virtual audio device. This is
what Eli hears.

## Pinning Important Audio Controls

One helpful feature of **Audio Hijack** is I can float and pin almost everything
in the UI. Here are my most frequently used controls dragged to the top corner
of my widescreen.

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-4.19.01-AM.png",
  alt="You can pin what you want, and ignore the rest."
)}}

This feature allows me to hide the convoluted chain of filters from my view
during the stream and focus on the few essential elements that matter most.

## Recent Changes After Our First Pilot

After our first pilot today, we decided it would be much easier to simplify
things by not streaming Zoom altogether. In addition, using Twitch's **Guest
Star** feature as an audio source worked better for Eli than Discord's audio.
So, for now, we'll use Discord only to share Eli's Desktop, and for his camera
and audio, we'll use Twitch's **Guest Star** feature.

Considering this, here's our (_quote_) "simplified" audio pipeline:

{{img(
  src="/images/2023/06/Screenshot-2023-06-16-at-12.34.34-PM.png",
  alt="Maybe not quite 'as' simple, but it looks good 🙂."
)}}

## A Dedicated Streaming Machine

> **Update 2021-05-27**
> 
> With [my new Mac Studio](@/about/volkan-uses.md) I don't need a dedicated
> streaming machine anymore. I can do everything on a single machine.
> 
> However, keeping a separate machine for streaming is still a good idea.

To ensure a smooth streaming experience I use two machines:

* A Mac Mini that I use as a demo/screencast machine. I'll call it the **demo
  machine**.
* And a Macbook Pro that I use specifically for OBS and streaming and nothing
  else. I make sure that nothing unnecessary runs on it. I'll call it the 
  **streaming machine**.

But why would I need a different machine to stream? Can't it be done on the same
box? Well, short answer: If you are using Apple devices, you'll have to 
**_cut many corners_** to make streaming on a single machine work flawlessly.
Using two machines provides better stream quality and will make my life much
easier.

For a longer answer: One of the challenges we tackled in our **TalkSPIFFE**
setup is managing the computational load of running demos while live streaming.
Since some of our demonstrations can be quite resource-intensive, performing
them on the same machine as the live stream could potentially degrade the
stream's quality, leading to lower bitrates, missing frames, and a sub-optimal
viewing experience.

To set this dual-machine configuration up, firstly, I connected the HDMI output
of my demo machine to an [**Elgato Camlink 4K** capture card](https://www.elgato.com/us/en/p/cam-link-4khttps://www.elgato.com/us/en/p/cam-link-4k),
which is plugged into my streaming machine. I created a 1080p virtual display on
my demo machine to share the required content using [**BetterDisplay**](https://github.com/waydabber/BetterDisplay).

After connecting it to the streaming machine, too, **Camlink 4K** identifies
itself as an additional display on my demo machine.

I mirrored the virtual monitor onto the Camlink 4K to have a separate view that
I can enlarge on my larger 32" monitor if I need to. In addition, the mirroring
allows me to use a copy of the demo window right in front of me so that I won't
have to tilt my unnecessarily on the live stream.

The following set of images shows what the overall setup looks like.

![](/images/2023/06/Screenshot-2023-06-15-at-2.57.58-PM.png)

![](/images/2023/06/Screenshot-2023-06-15-at-2.58.03-PM.png)

![](/images/2023/06/Screenshot-2023-06-15-at-2.58.21-PM.png)

![](/images/2023/06/Screenshot-2023-06-15-at-2.58.34-PM.png)

![](/images/2023/06/Screenshot-2023-06-15-at-2.59.56-PM.png)

The feed from the **Camlink 4K** is then directed into 
[**OBS**](https://obsproject.com/) on my streaming machine. You can check the 
"Physical Setup" section for additional details on how things connect at the
physical layer.

Once things are set up this way, the demo machine shoulders the burden of
resource-intensive demos. In contrast, my streaming machine remains dedicated to
delivering a smooth streaming experience without system degradation.

## Making Stream Management Easier

However, this dual-machine arrangement necessitates fast switching between the
two systems during a live stream. To overcome this challenge, I adopted a few
strategies:

### Network Stability

**All** **of my connections are wired** to ensure stable network connectivity. I
learned the hard way long ago never to rely on WiFi for such a critical setup.

### Remote Connection to the Streaming Machine

To streamline the control process, I remotely connect to my streaming machine
from my demo machine. This way, I can use a single keyboard to interact with
both machines.

### Keyboard and Mouse that Can Connect to Multiple Devices

There can be tricky moments when I need to move my mouse pointer into the
virtual monitor -- a task that's impossible when you are remotely connected. To
circumnavigate this, I use a 
[**Logi MX Master Wireless Mouse**](https://www.logitech.com/en-us/mx/master-series.html), 
which can be connected to up to three machines.

**Logi MX Master**'s ability to instantly switch from one machine to another
allows me to directly control the cursor on the streaming machine when required.
As a fail-safe, I also keep an old (_but in perfect working condition_) wired
mouse connected to my streaming machine (the MacBook Pro). I never fully trust
remote connectivity!

I've crafted a resilient system that handles resource-heavy demonstrations while
maintaining high-quality live streaming by implementing these strategies.

This is a testimony to the idea that you can overcome the challenges and
constraints inherent in live streaming with careful planning and a bit of
technological creativity.

## Video Setup

The video setup is comparably simpler than the "_auido_" one.

First of all, I only need to modify my camera's properties. I need to change
them only because I am using a green screen. Otherwise, I could very well use my
camera feed as is.

I'll also stream Eli's camera feed as is without any modification.

Besides, I have a pretty good camera 
([**_Panasonic HC-V180K_**](https://shop.panasonic.com/cameras-and-camcorders/camcorders/consumer-camcorders/hc-v180k))
that makes my life much easier.

I just applied some alpha filter and color correction to my camera.

Here is the end result:

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-8.18.44-AM.png",
  alt="Me in front of the green screen, chroma key and color correction applied."
)}}

And here are the settings for the "*color correction*" and "*chroma-key*"
filters, respectively:

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-8.20.27-AM.png",
  alt="Color correction settings."
)}}

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-8.20.53-AM.png",
  alt="Chroma key settings."
)}}

## Screen Annotations

You remember the orange arrows in the "*Audio Device Chain*" section? I made
them using [**Presentify**](https://presentify.compzets.com/).

The benefit of **Presentify** is it's not only for annotating static images like
this. You can use Presentify for online classes, video presentations, or
tutorials by letting you annotate your screen and highlight your cursor, even
when the application you are drawing over is in full-screen mode.

It's a great helper, especially when you are demonstrating technical content.
It's one of those tools you don't know how much you need before using.

## Composing Scenes

I already showed the camera setup for myself and my guest Eli.

I have two scenes in **OBS** that include those cameras in them. Having a
separate scene for the camera instead of directly embedding the cameras in the
scenes gives me the flexibility to modify them and reflect the changes in all
the scenes I use.

For example, if I add a blue border around the camera view, it will be reflected
everywhere the camera view is used; I won't have to repeat adding that border
around the camera to all of the scenes.

In addition, I can apply filters both to the camera and to the scene itself.
This layered composition of color correction and chroma key filters gives more
flexibility in configuring the sources.

Also, if I have a problem with a camera source like it is scaled incorrectly or
not showing up, I can fix it in one scene instead of jumping into every scene
that uses the camera and setting it one by one.

That part clarified, let's begin with the camera scenes and go all the way up,
building larger and larger scenes from sub-scenes.

## Camera Scenes

That's the source of my camera schene called "**my-camera**."

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.19.47-AM.png",
  alt="My camera."
)}}

And that's the source of Eli's camera view, which is a browser source from
Twitch Guest Star. The view is very creatively named "**twitch-guest-slot-1**".

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.22.38-AM.png",
  alt="Twitch guest slot 1."
)}}

The image source named **frame** is a blue image to give a distinct border
around both of the camera feeds similar to the one below:

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.20.41-AM.png",
  alt="Teal border."
)}}

## Talking Heads

After setting up the camera primitives, I compose those "**_my-camera_**" and 
"**_twitch-guest-slot-1_**" scenes as the camera feeds into larger screens.

Below is the source layout named "**_talking-head_**," containing the two camera
scenes mentioned before.

Again, this "**_talking-head_**" scene is a **sub-scene** that will be composed
into different scenes.

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.20.09-AM.png",
  alt="Talking head."
)}}

Here's how the scene looks:

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.20.56-AM.png",
  alt="Talking heads on the lower third."
)}}

## Side by Side

Here is the source layout of another scene named "**_talking-heads-lg_**."

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.20.18-AM.png",
  alt="Larger talking heads."
)}}

It creates a larger layout with our names and some turtle embellishments, again
to be embedded into more concrete scenes.

Below you can see what the combined view looks like. Note that there are camera
feeds inside the boxes. Right now, they are disabled, so the boxes look black
and empty.

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.21.02-AM-1.png",
  alt="Talking heads (larger)."
)}}

## Demo Over Zoom

Here's how the "_**talking-heads**_" scene is embedded into a view that shares a
full-screen zoom session (_which, on my OBS Scenes panel, is very creatively
named... ... ... "**Zoom**"_ 🙂) so that both of our camera feeds will be visible
when either Eli, or I am demonstrating something over Zoom.

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.37.11-AM.png",
  alt="The zoom view."
)}}

Here is the list of sources in this scene:

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.38.00-AM.png",
  alt="The Zoom view's sources"
)}}

As you see, even the **Asus|Dummy(Zoom)** view (_highlighted above_) is a scene
in itself. Here's its source layout.

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.40.03-AM.png",
  alt="Dummy capture device."
)}}

The naming suggests that the view reflects a dummy 1080p virtual monitor 
(*created using [**_BetterDisplay_**](https://github.com/waydabber/BetterDisplay#readme)*), 
which a real 1080p Asus monitor mirrors.

A virtual display is helpful; I can mirror one of my main displays to it and
have it as a small overview on my large central display, like a rear-view mirror
of sorts so that I don't miss the action in my peripheral vision when I focused
managing scene transitions and other stream properties.

Keeping the screens bound to 1080p resolution helps me quickly share anything on
the stream at 1080p resolution. This includes full-screen windows too. I can
drag a Zoom desktop sharing session or a remote desktop connection to a
different device or a browser window. Literally, I can easily show anything I
can see on my streaming machine to the audience in 1080p resolution. Having a
spare monitor to stream things gives **a lot** of flexibility.

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.40.22-AM.png",
  alt="Display capture."
)}}

I also have a third 1080p monitor that I also pair with a dummy monitor
and [Elgato Cam Link 4k](https://www.elgato.com/us/en/p/cam-link-4k) so that I
can share my demo machine's desktop with ease:

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-1.32.54-PM.png",
  alt="Streaming my demo machine's desktop."
)}}

Here is how to compose my desktop into any view:

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-1.41.09-PM.png",
  alt="Adding the desktop view into another view."
)}}

And here are the details of the "**_(my desktop) cam link4k_**" view highlighted
above:

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-1.41.21-PM.png",
  alt="Camlink video source view."
)}}

It has **Elgato Cam Link 4K** as the input source and nothing else. Having a
view with a single source might look unnecessary; however, this setup gives the
flexibility to manage the camera, and if something happens to the camera view,
then I'll only have to fix it in a single place.

## The Fireside Chat

Here's the "**_Fireside Chat_**" screen, where my and Eli's cameras are
displayed side-by-side. Again, the cameras are off in this screenshot, but both
of our camera feeds will be there in the live stream.

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.20.18-AM-1.png",
  alt="Fireside chat."
)}}

Here is the source layout of the above scene.

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.20.18-AM-1.png",
  alt="Fireside chat sources."
)}}

And here is what the **twitch-guest-slot-1** sub-scene looks like:

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-11.22.38-AM-1.png",
  alt="Twitch guest slot sub-scene."
)}}

It has a teal frame and a browser source from [Twitch Guest Star](https://help.twitch.tv/s/article/guest-star).

## The Big Red Clock

Yes, the clock is green to fit the overall theme, but the application's name
is [**The Big Red Clock**](http://www.bigredclock.com/), and it does its job
amazingly well. It's an app I use as a countdown timer before the show starts or
whenever we need a break.

{{img(
  src="/images/2023/06/Screenshot-2023-06-13-at-1.22.34-PM.png",
  alt="The big red clock."
)}}

To make it blend in better, I add the following color key filters:

{{img(
  src="/images/2023/06/Screenshot-2023-06-16-at-2.47.51-PM.png",
  alt="Big red clock color filters."
)}}

And for extra flexibility, I manage the big red clock in its own scene as well:

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-1.48.42-PM.png",
  alt="Big red clock alignment."
)}}

## The Interstitials

We use these "**_break screens_**" during the show whenever needed.

Aside from positioning the **Big Red Clock**, not much configuration is needed.
I'll share them here for the sake of completeness.

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-1.50.47-PM-1.png",
  alt="Starting soon."
)}}

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-1.50.54-PM-1.png",
  alt="Be right back."
)}}

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-1.51.04-PM.png",
  alt="End of stream."
)}}

## Streaming from Twitch to Zoom

Sharing the Zoom session on Twitch is easy: There is a scene for that. However,
if you wanted to send a copy of the Twitch stream back to zoom, it's not that
straightforward.

Luckily, there is a quick hack: **OBS Virtual Camera**.

Press this big fat button, and you can send the entire stream as a camera source
to any application that accepts virtual camera sources.

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-2.19.38-PM.png",
  alt="OBS virtual camera."
)}}

Here's how the camera feed looks on a movie player that can display camera views
too:

{{img(
  src="/images/2023/06/Screenshot-2023-06-14-at-11.55.58-AM.png",
  alt="OBS virtual camera output."
)}}

## My Mini Studio

Here's how things look from the outside:

{{img(
  src="/images/size/w1000/2023/06/IMG-7330.jpg",
  alt="My workspace."
)}}

Let me unpack the mess for you:

* I have a green screen behind me.
* A light source to my left is designed to diffuse light gently. And since I
  have a white and low ceiling, it creates evenly-spread natural-looking
  lighting on me and on the curtain without creating solid shadows. When
  possible, bouncing light off of surfaces is always a better option than
  directly pointing it to the subjects (_the "subject" being me sitting on the
  chair in this case_).
* There's a warm fill light below, and [you can get the fixture (**_ISJAKT led 
  floor uplighter_**) from 
  Ikea](https://www.ikea.com/us/en/p/isjakt-led-floor-uplighter-reading-lamp-dimmable-nickel-plated-70459716/).
* There are two [**Neewer Key Lights**](https://www.amazon.com/gp/product/B07T8FBZC2) in front of me. They are
  dirt cheap and are as effective as their expensive counterparts. But of
  course, you get what you pay for: there are no remote controls, you cannot
  change the color of the LEDs mid-stream, and you need to adjust its levels
  manually by pressing the buttons. But other than that, the lights' quality,
  spread, and intensity are excellent. And nothing can compete with its
  price-over-performance ratio.
* There's a camera directly focused on me at an angle from above. It's my
  faithful [**_Panasonic HC-V180K_**](https://shop.panasonic.com/cameras-and-camcorders/camcorders/consumer-camcorders/hc-v180k).
* I have one sizeable curved monitor as my main stage and two 1080p monitors to
  display my guest's screen and my demo machine's desktop, respectively.
* The large monitor is connected to my demo machine, and I established a remote
  desktop connection to the stream machine.
* If needed, there is a button below the monitor that I can switch to view the
  desktop of the streaming machine without having to remotely connect to it as a
  backup measure.

## Video and Audio Capture Layout

To put things into more perspective, here's a schematic of the stream-related
hardware that I use:

{{img(
  src="/images/2023/06/hardware-setup.jpg",
  alt="Streaming setup."
)}}

The demo machine and the camera are connected to the streaming machine as video
input sources through capture cards. I use 
[**Elgato HD60S+**](https://help.elgato.com/hc/en-us/articles/360034170131-Elgato-Game-Capture-HD60-S-Technical-Specifications)
and [**Elgato Cam Link 4K**](https://www.elgato.com/us/en/p/cam-link-4k) for
capture cards.

I like **Cam Link 4K** for its small form factor, but **HD60S+** offers a
pass-through HDMI output, which can sometimes be helpful.

[**Focusrite Scarlett Solo**](https://store.focusrite.com/en-gb/product/scarlett-solo-3rd-gen/MOSC0024DM~MOSC0024DM)
is my amplifier choice, and [**Shure SM7B**](https://www.shure.com/en-US/products/microphones/sm7b?variant=SM7B)
is a microphone I cannot live without.

There's also [**CloudLifter**](https://www.amazon.com/Cloud-Microphones-CL-1-Cloudlifter-1-channel/dp/B004MQSV04)
as a signal booster. I use it to boost the gain of the audio signal, clean it,
and improve the overall signal-to-noise ratio.

But why do I need that gain boost? Because while **Shure SM7B** is known for its
rich and detailed sound (_and hefty price tag_), it also has a relatively low
output level compared to many other microphones. This means that it requires
more gain from the preamp in the audio interface or mixer to produce a strong,
clean signal.

## Camera and Lighting Setup

I use a [**Panasonic HC-V180K**](https://shop.panasonic.com/cameras-and-camcorders/camcorders/consumer-camcorders/hc-v180k)
camcorder to stream myself. It's known for its superior performance under good
lighting and has never failed me once so far. The Panasonic HC-V180K feeds
directly into the Elgato HD60S+ capture card, ensuring a crystal-clear,
high-definition video feed.

Lighting is essential to any high-quality video setup, and ours is no exception.
My [**Neewer Key Lights**](https://www.amazon.com/gp/product/B07T8FBZC2),
positioned strategically behind the camera as you see below:

{{img(
  src="/images/2023/06/IMG-7337.jpg",
  alt="Camera and key lights."
)}}

But... but... but! There's something else. What's this little dude?

{{img(
  src="/images/2023/06/Screenshot-2023-06-15-at-3.17.17-PM.png",
  alt="Perry?"
)}}

Well, meet Perry the Platypus!

I use him as an odd trick to complement my stream.

But **how**, or before that, **why**?!

Because to connect to your audience and establish an intimate streaming
experience, you have to make eye contact with the camera.

The problem is: Making eye contact with a camera feels **weird**; it feels like
looking in the eye of a Cyclops, and it gets irritating (_for me, at least_).

That's where **Perry** helps. Instead of the camera, I see eye-to-eye with him,
and I look around the vicinity of the camera. Since the camera is far away, and
Perry sits within a few degrees of my line of sight, it's as good as looking
into the camera itself.

Just look at him; how can you say no to this little trouble maker 🙂:

{{img(
  src="/images/2023/06/IMG-7338.jpg",
  alt="Perry!"
)}}

Aside from the key lights, I use a white oval light source to achieve a more
natural and even light spread with reduced shadows.

This light bounces off the ceiling, subtly illuminating me and the green screen.
It allows greater flexibility when adjusting the camera's chroma key and color
correction filters in OBS.

{{img(
  src="/images/2023/06/IMG-7336.jpg",
  alt="Bouncing light off of solid surfaces."
)}}

And finally, to add depth and warmth to the video, I use a small fill light.
Emitting a warm off-white yellow light, it delicately balances any shadows on my
face and adds a touch of warmth to the overall video.

{{img(
  src="/images/2023/06/IMG-7335.jpg",
  alt="Fill light."
)}}

Of course, this is only possible with the final piece of our video setup: the
green screen. Acting as a backdrop, it allows me to overlay any desired
background during the streaming process, lending an additional layer of
professionalism and versatility.

{{img(
  src="/images/2023/06/Screenshot-2023-06-16-at-10.45.42-PM.png",
  alt="The green screen."
)}}

For your needs, any green screen would do. I use 
[**Instahibit Retractable Green Screen 
Backdrop**](https://www.amazon.com/Instahibit-Retractable-Backdrop-Chromakey-Mountable/dp/B087V2DHTW).

## Smoothing the Acoustics

Sound in the rooms gets bouncy, especially when that room is not a professional
recording studio. In the quest for crisp and clear sound, I have taken measures
to address potential acoustic challenges too. One of the essential steps in this
direction is using **acoustic canvas panels**.

Strategically placed around the room, these panels are vital in managing the
sound environment. Muffling the sounds bouncing off the walls significantly
reduces any potential echo or reverb. This results in a clearer and more
professional-sounding audio output for our stream.

Playing the right sound effects at the right moment during the stream is also a
lot of fun. For that, I use [**Farrago**](https://rogueamoeba.com/farrago/),
which, to me, is the best rapid soundboard ever: Robust, easy to use, and
integrates with almost everything, including your midi keyboard.

{{img(
  src="/images/2023/06/Screenshot-2023-06-16-at-11.23.47-AM.png",
  alt="Farrago."
)}}

After all, no stream is fun without a bleating goat in it!

## Bonus: Game Streaming

This one is not directly related to **TalkSPIFFE**, but I use it when I stream
games. And Twitch is not much fun if you don't stream video games every once in
a while.

Since video games use many system resources, I follow a similar strategy and use
my **capture card** to stream my demo computer's desktop to **OBS** on my
streaming computer.

And for the audio, I use **Audio Hijack** to redirect the game audio to the
capture card and then from the capture card to one of the virtual audio devices
that **OBS** is listening to.

The audio chain below links my game audio onto the capture card:

{{img(
  src="/images/2023/06/Screenshot-2023-06-16-at-8.07.21-PM.png",
  alt="Game audio to capture card."
)}} 

And this chain links the sound from the capture card to the loopback audio that
OBS takes as an input source.

Sending audio through the capture card does not have to be game-related. You can
get clever with it. For example, I'm thinking of using the Discord audio in my
demo machine instead of the streamer machine and shoving its audio through the
capture card:

{{img(
  src="/images/2023/06/Screenshot-2023-06-17-at-9.29.44-AM.png",
  alt="From discord to capture card."
)}}

Then, I can use it as an audio source, instead of the guest start audio that
comes from Twitch, and disable the "_guest star_" Chrome audio input entirely as
shown below:

{{img(
  src="/images/2023/06/Screenshot-2023-06-17-at-9.32.26-AM.png",
  alt="From capture card to guest in."
)}}

That would mean running one less application on the stream machine, which would
ensure an even smoother streaming experience.

Finally, here is how the game looks on OBS, the game audio streaming from the
Vocals track is seen below:

{{img(
  src="/images/2023/06/Screenshot-2023-06-16-at-8.08.04-PM.png",
  alt="Game streamed in OBS with audio coming from the virtual device."
)}}

## Conclusion

Remember that every stream is different, and every streamer's' setup, needs, and
wants will differ too. Though I hope that this article can help some of you
folks inspire and that you can use it as a starting point in your streaming
journey.

And things change. There is no perfect setup; you keep on adjusting. For
example, after our first pilot we realized that streaming to Zoom caused some
audio echo/feedback issues on the "guest" end of things, and we decided it's not
worth it at the moment for two reasons:

1. First, since we don't have a very large audience (yet), it's not worth
   splitting it to multiple venues. We can use Twitch as the one single place to
   stream things, and we can use SPIFFE slack workspace for questions. That
   would unite the community and will result in people exchanging comments and
   ideas in the same medium instead of spreading the creative juice to several
   mediums.
2. Second, it makes things simpler to manage, and with less moving parts there's
   less possibility to make errors too.

That said, the world of live-streaming is an ever-evolving landscape, one that's
limited only by the boundaries of your imagination. Whether you're a seasoned
streamer or just dipping your toes into these waters, remember that every stream
is an opportunity to learn, grow, and create unforgettable experiences for your
viewers.

Keep pushing the boundaries, and may the source be with you 🦄.

--------

## Section Contents

{{ tips_nav(selected=9) }}
