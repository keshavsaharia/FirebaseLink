BeginPackage["Firebase`FirebaseLink`"];

Firebase::usage = "Firebase[path] is a symbolic representation of a Firebase.";
FirebaseAuthenticate::usage = "FirebaseAuthenticate[token] authenticates this client with the given Firebase secret token.";
FirebaseUnauthenticate::usage = "FirebaseUnauthenticate[] removes the current authentication token.";
FirebaseURL::usage = "Returns the URL corresponding to the symbolic Firebase.";

FirebasePush::usage = "FirebasePush[firebase, data] and FirebasePush[firebase, path, data] pushes the data at the corresponding Firebase location.";
FirebaseWrite::usage = "FirebaseWrite[firebase, data] and FirebaseWrite[firebase, path, data] write the specified data to the corresponding path on Firebase.";
FirebaseRead::usage = "FirebaseRead[firebase, path] returns the data on the corresponding Firebase path.";
FirebaseUpdate::usage = "FirebaseUpdate[firebase, data] and FirebaseUpdate[firebase, path, data] update the firebase at the corresponding location with data.";
FirebaseDelete::usage = "FirebaseDelete[firebase] and FirebaseDelete[firebase, path] remove the data at the specified path in the firebase.";

FirebaseChild::usage = "FirebaseChild[firebase, child] returns the child of the specified firebase.";
FirebaseParent::usage = "FirebaseParent[firebase] returns the parent of the specified firebase.";

$FirebaseToken = 0;
$FirebaseCurlBuffer = "";
$FirebaseUseBuffer = True;

Begin["`Private`"];

$FirebaseToken = 0;
$FirebaseCurlBuffer = CreateTemporary[];
CurlRequest[verb_, data_, url_] := If[$FirebaseUseBuffer,
	Export[$FirebaseCurlBuffer, data, "JSON"];
	Import["!curl -X "<>verb<>" -H 'Content-type:application/json' --data @"<> $FirebaseCurlBuffer <> " '"<> url <>"'", "JSON"],
	Import["!curl -X "<>verb<>" -H 'Content-type:application/json' -d '"<> CurlEscape[data] <> "' '"<> url <>"'", "JSON"]
]
CurlPost[data_, url_] := CurlRequest["POST", data, url]
CurlPatch[data_, url_] := CurlRequest["PATCH", data, url]
CurlPut[data_, url_] := CurlRequest["PUT", data, url]
CurlDelete[url_] := Import["!curl -X DELETE '"<> url <>"'", "JSON"]
CurlGet[url_] := Import["!curl "<>url, "JSON"]

CurlEscape[data_] := 
	If[StringQ[data], "\"" <> data <>"\"", 
	If[NumberQ[data], ToString[data], 
	If[ListQ[data],StringReplace[ExportString[data,"JSON"],
		(""|Whitespace..)~~("\t"|"\n")~~(""|Whitespace..)->""]]]]

FirebaseAuthenticate[token_] := ($FirebaseToken = token);
FirebaseUnauthenticate[token_] := ($FirebaseToken = 0);
FirebaseURL[firebase_] :=
	If[StringQ[firebase], firebase, 
		If[ListQ[First[firebase]], 
			FirebaseURL[Firebase[FileNameJoin[First[firebase]]]],
			"https://"<> FileNameTake[First[firebase], 1]<>".firebaseio.com/" <> 
				FileNameDrop[First[firebase], 1]<>"/.json"<>
		If[StringQ[$FirebaseToken],"?auth=" <> $FirebaseToken, ""]]]
FirebasePush[firebase_, data_] := CurlPost[data, FirebaseURL[firebase]]
FirebasePush[firebase_, path_, data_] := CurlPost[data, FirebaseURL[FirebaseChild[firebase, path]]]
FirebaseWrite[firebase_, data_] := CurlPut[data, FirebaseURL[firebase]]
FirebaseWrite[firebase_, path_, data_] := CurlPut[data, FirebaseURL[FirebaseChild[firebase, path]]]
FirebaseUpdate[firebase_, data_] := CurlPatch[data, FirebaseURL[firebase]]
FirebaseUpdate[firebase_, path_, data_] := CurlPatch[data, FirebaseURL[FirebaseChild[firebase, path]]]
FirebaseDelete[firebase_] := CurlDelete[FirebaseURL[firebase]]
FirebaseDelete[firebase_, path_] := CurlDelete[FirebaseURL[FirebaseChild[firebase, path]]]

FirebaseRead[firebase_] := CurlGet[FirebaseURL[firebase]]
FirebaseRead[firebase_, path_] := CurlGet[FirebaseURL[FirebaseChild[firebase, path]]]
FirebaseChild[firebase_, child_] := Firebase[FileNameJoin[{First[firebase], child}]]
FirebaseParent[firebase_] := Firebase[FileNameDrop[First[firebase], -1]]

End[];
EndPackage[];
