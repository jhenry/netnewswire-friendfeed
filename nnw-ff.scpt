property theFriendFeedUser : ""
property theFriendFeedSecretKey : ""

tell application "NetNewsWire"
	set theArticle to the selectedHeadline
	if theArticle is not false then
		set theText to the description of the theArticle
		set theLink to the URL of theArticle
		set theTitle to the title of theArticle
		set theBlog to the givenName of the subscription of theArticle
		set theBlogLink to the home URL of the subscription of theArticle
		do shell script "curl -u \"" & theFriendFeedUser & ":" & theFriendFeedSecretKey & "\" -d \"title=" & theTitle & "&link=" & theLink & "\" http://friendfeed.com/api/share"
	end if
end tell

on checkUsernameAndPassword()
-- Check to see if the file where our username and password are stored exists
    try
        do shell script "cd " & POSIX path of (path to preferences as text) & "; ls | grep com.larrystaton.toread.txt"
        try
            set prefFile to ((path to preferences as text) & "com.greengaloshes.nnw-ff.txt")
            open for access file prefFile with write permission
                set prefs to read file prefFile using delimiter {return}
            close access file prefFile
            set usernamePasswordString to item 1 of prefs
            on error e
                close access file prefFile
        end try
        on error
            set username to text returned of (display dialog "Please enter your friendfeed username" default answer "username")
            set pass to text returned of (display dialog "Please enter your friendfeed secret key (https://friendfeed.com/account/api)" default answer "password")
        try
            set prefFile to ((path to preferences as text) & "com.greengaloshes.nnw-ff.txt")
            open for access file prefFile with write permission
                set eof of file prefFile to 0
                write username & ":" & pass & {return} to file prefFile
            close access file prefFile
            on error e
                close access file prefFile
        end try
        -- set usernamePasswordString to username & ":" & pass
        set theFriendFeedUser to username
        set theFriendFeedSecretKey to pass
    end try
end checkUsernameAndPassword