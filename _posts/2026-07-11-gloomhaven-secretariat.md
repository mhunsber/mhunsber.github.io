---
title: Origins - Gloomhaven Secretariat and what I learned about my ISP
description: In which I explain why this site even exists
date: 2026-09-26 16:30:00 -0400
categories: [blog, board-games, tech]
pin: true
---

About a year ago, I convinced my girlfriend and two other friends to hang out with me on a weekly-ish basis to play through the
Gloomhaven series of games. Gloomhaven and all other "haven" games are some of my favorite gaming experiences (both in digital and physical), but playing them is a bit of a commitment because the game has a storyline and progression that your characters follow.
The game mechanics are also complex: There's monster movements that follow strict rules, conditions that affect how much
damage you take or deal, turn order changes every round based on what cards you choose to play, and every player has a different
set of cards and abilities they can use. When you sit down to play through a scenario, you have to manage a lot of components:
character sheets for each player to track their gold, experience, and items they gained from previous game seesions;
interlocking board tiles to build out the scenario map; punch-out tokens to mark obstacles, traps, or other terrain details;
and monster standees to move around the map alongside your character miniatures.
There are also components for tracking health and current conditions for both yourself and the monsters you encounter
during a scenario.

All the pieces and widgets you need to track that progression, health, and conditions come with the game. It is entirely possible,
and often rewarding, to run a campaign just with what's provided out of the box. However, a lot of players will seek ways to make
these kind of "admin" tasks easier. The most immersive option is to create (or buy) your own trackers and tactile components: Just look up
"Gloomhaven monster trackers" on your favorite search engine: You'll get pages of results. The more accessilbe (and lower-profile) option, though,
is to use what's known as a "helper app" on your phone or computer to track the game's state.

As much as I would enjoy custom pieces and trackers, I like the simplicity and efficiency of using a helper app.
Initially, though, I had my friends play Gloomhaven: Jaws of the Lion (JoTL) using the provided components because they had never played before
and I believe the helper apps make it too easy to ignore certain subtleties to game mechanics; subtleties that are important to understand
in order to make informed decisions while playing.

> **Quick Aside**: JoTL has one of the smoothest box-to-table experiences out there, especially for a game of its complexity.
When you open the box, you're greeted with a single page that tells you exactly what to do first.
By slowly introducing new mechanics as you play through the tutorial, it lets you start playing the game before you have even opened all its components.
Compare that to the experience of other, even much simpler games, where you have to open all the components, read through the entire rulebook, and then slog through your first game (or two!) because you're checking and rechecking the rules.
{: .prompt-info }

As an example of one of these important to understand mechanics, each monster type has a small deck of eight cards for their abilities.
Each round, the top card gets revealed to indicate how that monster type will act during the round: Will it move? How far? Will it attack? How hard?
Every monster type also has two cards with a "reshuffle" symbol on it. If that card gets drawn, then at the end of the round you shuffle all the
ability cards back into the monster's deck. Administratively, this creates annoying toil: Every round, for each monster type, you have to flip over a card;
and then, at the end of each round, for each monster type, you need to check all the decks and reshuffle ones with a reshuffle symbol.
The helper app just does that for you: You click "start round" and all cards are revealed. The reshuffle mechanic makes it so the
abilities marked for reshuffling are always _possible_ to draw, which means the monsters perform those actions more frequently.
The helper apps do not _hide_ that these cards reshuffle, but since you are not spending the time to physically
reset the deck, it becomes easy to forget (or just never notice) and wonder why that Cultist you ignored earlier has drawn its
"Summon Living Bones" ability for the **third turn in a row** and now you feel overwhelmed by the swarm of skeletons heading toward you.

Once my friends "graduated" from the tedious method of playing, I had to choose which helper app to use. The Gloomhaven subreddit wiki lists
[over a dozen apps](https://www.reddit.com/r/Gloomhaven/wiki/community/apps/). In previous playthroughs, I had used an app called X-Haven
Assistant, but I wanted to try out Gloomhaven Secretariat. I was enticed by its more full featureset like the ability
to track the broader campaign progression rather than just scenario-level details. We started using Gloomhaven Secretariat by connecting
each of our phones to one of the public servers, but we often experienced disconnects. During disconnects, we had to resort to a single device until it came
back online and everyone reconnected. These interruptions were usually short-lived (maybe fifteen to thirty minutes at the longer end), but
frequent enough that I got the idea in my head to just host it myself. I'm an infrastructure engineer approaching a decade of enterprise experience;
running a little web service within my own network should be a cinch...

> As engineers, we do things not because they are easy, but because we thought they were going to be easy.

I should, perhaps, clarify what I mean by hosting it myself. I only needed my friends and I to use this app when they were over to play the game.
I did not need anyone to be able to connect when they weren't physically at my apartment and connected to my Wi-Fi.
In some ways, this could have been incredibly simple because running the [Gloomhaven Secretariat server](https://github.com/Lurkars/ghs-server) is 
actually very straightforward. I could have just installed the server on my laptop, started it up whenever my friends came to play, looked up whatever my 
laptop's current local IP address is, then told my friends to open their browsers on their phone and type that IP address into the address bar.
Bada bing. Bada boom.

I did not like this solution, though, because... well... when you load it on your phone's browser it still has all that browser _stuff_ at the top,
and it's not **really** full screen. When you use the [official public server](https://gloomhaven-secretariat.de/), you're asked if you want to install the site "as an app".
This creates an app icon on your phone's home screen and makes the whole experience feel more like an app and less like a website: polished.

> These kinds of apps are called [Progressive Web Apps](https://en.wikipedia.org/wiki/Progressive_web_app) (PWAs).
They are convenient because they can be written almost identically to a website and used on pretty much any device that supports a modern web browser. 
In other words, you don't have to develop and publish separate applications for Android, iOS, Windows, etc.
{: .prompt-info }

If I wanted my friends to be able to have that same fullscreen experience, I would need to be able to make my instance of Gloomhaven Secretariat
work as a Progressive Web App. Two main barriers faced me: The first (public key infrastructure) I anticipated; the second (my ISP's DNS) I did not.

The first barrier, public key infrastructure, is the reason (as promised in the description) this site even exists.
You may have noticed that when you see links to websites, they usually start with `https://`.
The `http` part stands for [Hypertext Transfer Protocol](https://en.wikipedia.org/wiki/HTTP), which is just a set of rules your
device follows to "talk to" (request and receive data from) the website server at the other end.
The `s` at the end is to specify that this communication should happen **securely** using an encrypted connection.
One of the benefits [HTTPS](https://en.wikipedia.org/wiki/HTTPS) provides over HTTP is a way for your device to verify that the server at
the other end of the connection is actually who they say they are. When your device first connects to the server at the other end, the server presents
something called a "certificate" that essentially states "**So-and-so** verifies that I am allowed to send data at **this website** until **sometime**."
Using some [fancy math](https://www.youtube.com/watch?v=86cQJ0MMses), your device looks at this certificate and checks a few things:

- Is So-and-so someone I trust?
- The certificate says it's for this website, is that the website I expect?
- It says "until sometime," is that still in the future?

If the answer to any of these questions turns out to be a "no," then you'll get an error page from your browser letting you know not to continue.

> **Examples!** You can see exactly what your browser will look like if any of these questions fail at <https://badssl.com/>.
- "Is So-and-so someone I trust?"  could be [self-signed](https://self-signed.badssl.com/), [untrusted-root](https://untrusted-root.badssl.com/), or [revoked](https://revoked.badssl.com/).
- "The certificate says it's for this website, is that the website I expect?" would look like [wrong.host](https://wrong.host.badssl.com/).
- It says "until sometime, is that still in the future?" would look like [expired](https://expired.badssl.com/).
{: .prompt-info }

PWAs require that all connections use HTTPS, so I needed a valid certificate from a trusted source (known as a Certificate Authority).
Naturally, that meant registering a domain: specifically, the one you're looking at.

Once I registered my domain, I could prove to a Certificate Authority that I controlled `ghs.mhunsber.dev` and get a certificate for my service.
The last piece of the puzzle was to make sure that when my friends typed "ghs.mhunsber.dev" into their app, their devices actually connected to my laptop running the Gloomhaven Secretariat server.
To do that, their devices would use the [Domain Name System (DNS)](https://en.wikipedia.org/wiki/Domain_Name_System)
to translate the domain name of "ghs.mhunsber.dev" to an [IP Address](https://en.wikipedia.org/wiki/IP_address),
which is similar to a phone number or postal address in that it represents a location to send or receive information.
When your device connects to a network (e.g. via wi-fi), it receives one of these IP Addresses so that it can send and receive information from other devices. When your device wants to connect to a domain (such as a website address), it first asks a DNS **server** what that domain's IP address is so that your device knows where to send its data.
Glossing over a lot of details, there are essentially two "kinds" of IP Addresses:

- **Public IP Addresses** work _between_ networks. Anytime you access something on "the Internet," your device addresses its communication to a public address.
- **Private IP Addresses** work _within_ a network. When you print something to a wireless printer, or you want to cast something to the TV, your device addresses that communication to a private address.

Your router (that box your Internet Provider sends you that has the blinking LEDs) acts like a bridge between these two spaces.
It gets a public address from your Internet Service Provider that it uses on the "outside", and creates a private address for itself to use on the "inside".
When your device tries to connect to something on the Internet, it passes over this bridge, where your router changes the "sent from" address from your device's private address to the router's own public address.
Then, when the service on the other side of that connection sends information back, your router does the same process, but in reverse, to make sure that information arrives at your device.
That automatic [translation](https://en.wikipedia.org/wiki/Network_address_translation) only works _if your device initiates_ the connection, and only lasts as long as your device keeps the connection alive.
If you wanted something from outside your network to initiate a connection to a device within your own network, you would have to [configure your router to allow it](https://en.wikipedia.org/wiki/Port_forwarding).
However, if you just want to connect devices within your own network, you don't need to do any of that;
The device initiating the connection (client), just needs to know the private address of the device receiving the connection (server).

Since I only cared about my friends being able to use the app when they were at my house, I just used my domain provider's DNS tool to set the
IP address for "ghs.mhunsber.dev" to the private address of my laptop. That **should** have been the end of the story:

1. My friends connect their phones to my wi-fi.
2. They browse to "ghs.mhunsber.dev".
  - Their devices use DNS to translate ghs.mhunsber.dev to my laptop's private address.
  - Their devices establish a connection to the GHS server running on my laptop.
  - Their devices verify the certificate, trust the service, and accept the server's response.
3. They download the site as a PWA.
4. We play.

I tested it. To my surprise, I got a big "Server not found" error in my browser. That error told me that my computer was not resolving the domain to an IP address.
For a moment I thought it could just take a while for the DNS change to take effect.
I waited a few minutes and tried again.

That still didn't work.

At this point, I knew something funky was going on. Earlier, I mentioned that a device asks a DNS server to translate the domain name to the IP address.
Usually, your router will tell your device what DNS server to use [when your device connects](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol). You can always manually set your DNS server, though, and there are [plenty of options](https://en.wikipedia.org/wiki/Public_recursive_name_server#Notable_public_DNS_service_operators). AT&T is my Internet Provider, which meant
devices on my network would get told to use AT&T's DNS servers for name lookups. I changed my computer's DNS servers manually. I tried again.

Everything worked.

I did a little more testing and troubleshooting, and discovered that AT&T's DNS servers [block lookups that resolve to private addresses](https://serverfault.com/a/1193470). For all of it to work, then, I needed to make sure everyone's device was using the right DNS server.
With every other router I had used, that was a simple change in the router's DHCP settings. But of course, to my dismay, the router AT&T provided me didn't have that setting.

At this point, I really only had two options: I could set up my own router in front of the AT&T one and actually have control of my network, or I could just manually set the DNS servers for the four devices I needed to run Gloomhaven Secretariat. Not wanting to spend a lot on networking equipment while
renting an apartment, I opted for the latter. The next time we all met to play Gloomhaven, I simply asked each for their phones, connected them to my wi-fi using a static IP address and configuring a public DNS resolver, and spun up the server on my laptop.

It's not the most elegant solution to have to set them all up individually (one of us changed phones between sessions and I had to set them up with a static address again), but it works and we don't have the interruptions from disconnects anymore.
Instead, we just have interruptions for normal reasons, like forgetting who said they were going to go early next round to finish off that pesky flying drake that keeps muddling us.
