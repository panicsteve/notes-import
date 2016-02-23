# notes-import
### Imports a folder of plaintext files into Apple Notes

Please see the "known issues" below before using.

I successfully used this on OS X 10.11 El Capitan.  It probably does not work on earlier versions of OS X.

```
//
// notes-import.scpt 
// Steven Frank <stevenf@panic.com>
//
// Import a folder full of HTML or text files into Notes.app.
// Crude, but better than nothing. Maybe?
//
// Usage:
//   - Open this file in Script Editor
//   - Change Script Editor language popup from AppleScript to JavaScript
//   - Run
//   - Select folder containing files to import
//
// Known issues:
//   - Attachments don't get imported
//   - Formatting/HTML is not preserved
//   - No idea how text encoding is handled
//   - File extension should be stripped from title of new note
//
```
