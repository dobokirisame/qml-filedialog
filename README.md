# File Picker

----------
Simple QtQuick file picker widget

Requires: Qt 5.7

License: MIT

Usage Example(shown in main.qml):

```javascript
FilePicker {
    anchors.fill: parent
    showDotAndDotDot: true
    nameFilters: "*.jpeg"
    onFileSelected: {
        console.log("User selects file: " + currentFolder() + "/" +fileName)
    }
}
```
----------
> **Note**
>It's a part of my android application project.
>That's why there is utils.js file with colors and dp calculator.
>I didn't find anything like this on github or bitbucket.
>It works not so well, but it works.
>It's small and easy to use in your project.
>Its default start folder is inside of application assets(when you run it on android device).
>Its filepath text does not replace all "/".
>


