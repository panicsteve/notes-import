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

var notesApp = Application('Notes')
notesApp.includeStandardAdditions = true
notesApp.activate()

// Prompt user to pick a folder

var folderName = notesApp.chooseFolder()

var folderContents = Application('System Events').folders.byName(folderName.toString()).diskItems.name()

var notesFolder = getNotesFolder();

folderContents.forEach(function(item) 
{
	var fileContents = fileContentsAtPath(folderName + '/' + item)
	
	if ( fileContents !== false )
	{
		var note = notesApp.Note({
			'name': item.replace(/\.\w{3,4}$/, ''),
			'body': fileContents
		})

		notesFolder.notes.push(note) 
	}
})

function fileContentsAtPath(pathAsString) 
{
	var path = Path(pathAsString)

	var app = Application.currentApplication()
	app.includeStandardAdditions = true
		
	try 
	{
		var file = app.openForAccess(path);
	}
	catch (e) 
	{
		return false;
	}
    
	var eof = app.getEof(file)
	var data = null
	
	try 
	{
		data = app.read(file, 
		{
			'to': eof
		});
	} 
	catch (e) 
	{    
		return false;
	} 
	finally 
	{
		app.closeAccess(file);
	}
	
	return data;
}

// Prompt user to pick a folder from chosen account if more than one

function getNotesFolder()
{
	var folderChoice;
	var acct = getNotesAccount();
	var folders = [];
	var msg = 'Which folder in ' + acct.name() + '?';
	
	if (acct.folders.length === 1) {
		return acct.folders[0];
	}
	
	for (var e in acct.folders) {
		folders.push(acct.folders[e].name())
	}
	
	folderChoice = notesApp.chooseFromList(folders, {
		withTitle: 'Folder for import',
		withPrompt: msg
	});
	

	return acct.folders[ folderChoice[0] ];
}

// Prompt user to pick an account in Notes app if more than one
function getNotesAccount()
{
	var acctChoice, acct;
	var options = [];
	var accts = notesApp.accounts;

	if (accts.length === 1)
	{
		return notesApp
	}

		for (var e in accts)  {
			options.push(accts[e].name());
		}
	
		acctChoice = notesApp.chooseFromList(options, {
			withTitle: 'Notes Account',
			withPrompt: 'Which account do you want to use to import your notes?'
		});

		return notesApp.accounts[ acctChoice[0] ];
}
