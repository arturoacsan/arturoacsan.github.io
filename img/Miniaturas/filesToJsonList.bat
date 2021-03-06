@if (@CodeSection == @Batch) @then
@echo off & setlocal

cscript /nologo /e:JScript "%~f0" "%~1"

goto :EOF
@end

var fso = WSH.CreateObject('Scripting.FileSystemObject'),
    htmlfile = WSH.CreateObject('htmlfile'),
    JSON = tree = Array = {},
    path = WSH.Arguments(0) || '.';

htmlfile.write('<meta http-equiv="x-ua-compatible" content="IE=9" />');
JSON = htmlfile.parentWindow.JSON;
Array = htmlfile.parentWindow.Array;
htmlfile.close();

function recurse(path) {
    var dir = fso.GetFolder(path),
        contents = new Array();

    for (var fc = new Enumerator(dir.SubFolders); !fc.atEnd(); fc.moveNext()) {
        var obj = {};
        obj[fc.item()] = recurse(fc.item());
        contents.push(obj[fc.item()]);
    }

    for (var fc = new Enumerator(dir.Files); !fc.atEnd(); fc.moveNext())
        contents.push(fso.GetFileName(fc.item()));

    var obj = {};
    obj[dir] = contents;
    return obj;
}

tree = recurse(path);

WSH.Echo(JSON.stringify(tree, null, '\t'));