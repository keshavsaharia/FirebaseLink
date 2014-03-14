FirebaseLink
============

FirebaseLink is a symbolic interface to [Firebase](https://firebase.com) from [Mathematica](http://wolfram.com). 

The easiest way to get started is to open FirebaseLink.m with Mathematica and evaluate it. You can also load it in by creating a folder with ```mkdir Mathematica.app/AddOns/ExtraPackages/Firebase``` and moving FirebaseLink.m to it.

```Mathematica
Get["Firebase`FirebaseLink`"]
```
FirebaseLink uses a REST API detailed in the [Firebase documentation](https://firebase.com/docs). It wraps functionality around the ```Firebase``` symbol.

```Mathematica
fb = Firebase["firebaselink"] (* Corresponds to https://firebaselink.firebaseio.com *)
child = Firebase["firebaselink/foo"] (* Corresponds to https://firebaselink.firebaseio.com/foo *)
example = Firebase[{"firebaselink", "foo", "bar", "baz"}] (* Corresponds to https://firebaselink.firebaseio.com/foo/bar/baz *)
```

Then, to write to the Firebase (or child of the Firebase):

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
