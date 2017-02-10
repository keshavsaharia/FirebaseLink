FirebaseLink
============
FirebaseLink is a symbolic interface to [Firebase](https://firebase.com) from [Mathematica](http://wolfram.com). 

The easiest way to get started is to open FirebaseLink.m with Mathematica and evaluate it. You can also load it in by creating a folder with ```mkdir Mathematica.app/AddOns/ExtraPackages/Firebase```, moving FirebaseLink.wl to it, and doing a `Get` on the package path.

```Mathematica
Get["Firebase`FirebaseLink`"]
```
FirebaseLink uses the REST API described in the [Firebase documentation](https://firebase.com/docs). The ```Firebase``` symbol is used to symbolically represent a Firebase with a given authentication token or secret key. It simplifies the longer URL (__x__.firebaseio.com/__y__) to just the prefix ```x``` and the Firebase path ```y```.

```Mathematica
(* fb points to https://firebaselink.firebaseio.com *)
fb = Firebase["firebaselink"] 
(* fb points to https://firebaselink.firebaseio.com/foo *)
fb = Firebase["firebaselink/foo"]
(* fb points to https://firebaselink.firebaseio.com/foo/bar/baz *)
fb = Firebase[{"firebaselink", "foo", "bar", "baz"}] 
```

The optional second parameter is the authentication token or secret key.
```
Firebase["firebaselink", "z897vasdj2k3j98y98yw8923hsklf..."]
```
The authentication token or secret key is necessary if you are using security rules on your Firebase. If you are just using a Firebase for a personal project and aren't too concerned about people stealing/vandalizing your data, you can leave out the authentication.

Creating a Firebase symbol is a lightweight operation, so it can be called in a mapping or large iteration. To write to a location:

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

Example Usage
===
Suppose you need to provide your web visitors with your company's most up-to-date share price. You could bust out your favorite web scraping language (Python, PERL, etc) and set up a cron job to scrape Google finance. I'd estimate it would take you about an hour, not counting the time you'd have to spend updating it whenever Google Finance's layout changes.

Here's how to get it done in 5 minutes with FirebaseLink.

1. Set up a Firebase. Refer [here](https://firebase.com/docs) if you don't know how to do this.
2. Make the Firebase publicly readable and writeable by editing the database rules to be:
```
{
    "rules": {
        ".read": true,
        ".write": true
    }
}
```

4. Set up a Mathematica script that connects to your firebase and writes the output from Mathematica's built-in ```FinancialData``` function.

```
fb = Firebase["example"]
FirebaseWrite[fb, FinancialData["GOOG"]]
```

5. Somewhere on your website, use the JavaScript API to read the share price.

```javascript
var fb = new Firebase("example.firebaseio.com");
fb.once('value', function(snap) { 
  var price = snap.val();
  $('#share-price').text('$' + price.toFixed(2) );
});
```

## Authentication tokens

If you generate a Firebase token to use with your database, you can pass it as the second parameter to `Firebase`.

```mathematica
secure = Firebase["name", "auth token"];
FirebaseRead[secure]
```

License
===
Do whatever you want with this. Email me a beer if it was helpful: [keshav@keshav.is](mailto:keshav@keshav.is)
