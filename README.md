FirebaseLink
============

FirebaseLink is a symbolic interface to [Firebase](https://firebase.com) from [Mathematica](http://wolfram.com). 

The easiest way to get started is to open FirebaseLink.m with Mathematica and evaluate it. You can also load it in by creating a folder with ```mkdir Mathematica.app/AddOns/ExtraPackages/Firebase``` and moving FirebaseLink.m to it.

```Mathematica
Get["Firebase`FirebaseLink`"]
```
FirebaseLink uses a REST API detailed in the [Firebase documentation](https://firebase.com/docs). It wraps functionality around the ```Firebase``` symbol. It simplifies the longer URL (__x__.firebaseio.com/__y__) to just the prefix ```x``` and the Firebase path ```y```.

```Mathematica
(* fb points to https://firebaselink.firebaseio.com *)
fb = Firebase["firebaselink"] 
(* fb points to https://firebaselink.firebaseio.com/foo *)
fb = Firebase["firebaselink/foo"]
(* fb points to https://firebaselink.firebaseio.com/foo/bar/baz *)
fb = Firebase[{"firebaselink", "foo", "bar", "baz"}] 
```
Just like the JavaScript Firebase library, creating a Firebase symbol is a very lightweight operation, so it can be called in a mapping or large iteration. To write to a location:

```Mathematica
FirebaseWrite[fb, "foo"]
FirebaseWrite[fb, {"foo" -> "bar"}]
FirebaseWrite[fb, {"foo" -> "bar", "baz" -> {"quux" -> {1, 2, 3, 4}}}]
```

You can get children of the Firebase on the fly:

```Mathematica
FirebaseWrite[FirebaseChild[fb, "foo/bar"], {"waldo", "fred"}]
```

To push data onto a list:

```Mathematica
FirebasePush[fb, "woohoo"]
FirebasePush[fb, "yippee"]
FirebasePush[fb, "shabooya"]
```
To read data:
```Mathematica
FirebaseRead[fb]
FirebaseRead[FirebaseChild[fb, "loud/noises"]]
```

Neat examples
===
Coming soon.

License
===
Do whatever you want with this. Email me a beer if it was helpful: [keshav@keshavsaharia.com](mailto:keshav@keshavsaharia.com)
