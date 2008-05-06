-- NNW to FriendFeed
-- Justin D. Henry
-- http://greengaloshes.cc

property theUser : ""
property theSecretKey : ""
property thePreferencesFileName : "com.greengaloshes.nnw-ff.txt"

checkUsernameAndPassword()
sendToFriendFeed()

on sendToFriendFeed()
    tell application "NetNewsWire"
     set theArticle to the selectedHeadline
     if theArticle is not false then
         -- TODO: set the default comment to selection 
         -- set theText to the description of the theArticle
         set theLink to the URL of theArticle
         set theTitle to the title of theArticle
         -- TODO: Figure out how to set a comment that doesn't get cut off? 
         -- set theComment to text returned of (display dialog "Add a comment (leave blank for no comment)." default answer "")
         do shell script "curl -u \"" & theUser & ":" & theSecretKey & "\" -d \"title=" & theTitle & "&link=" & theLink & "\" http://friendfeed.com/api/share"
     end if
    end tell
end sendToFriendFeed

on checkUsernameAndPassword()
-- Check to see if the file where our username and password are stored exists
    try
        do shell script "cd " & POSIX path of (path to preferences as text) & "; ls | grep " & thePreferencesFileName
        try
            set prefFile to ((path to preferences as text) & thePreferencesFileName)
            open for access file prefFile with write permission
                set prefs to read file prefFile using delimiter {return}
            close access file prefFile
            set theUser to item 1 of prefs 
            set theSecretKey to item 2 of prefs 
            on error e
                close access file prefFile
        end try
        
        on error
            set username to text returned of (display dialog "Please enter your friendfeed username" default answer "")
            set pass to text returned of (display dialog "Please enter your friendfeed secret key (https://friendfeed.com/account/api)" default answer "")
        try
            set prefFile to ((path to preferences as text) & thePreferencesFileName)
            open for access file prefFile with write permission
                set eof of file prefFile to 0
                -- write username & ":" & pass & {return} to file prefFile
                write username & {return} to file prefFile
                write pass & {return} to file prefFile
            close access file prefFile
            on error e
                close access file prefFile
        end try
        -- set usernamePasswordString to username & ":" & pass
        set theUser to username
        set theSecretKey to pass
    end try
end checkUsernameAndPassword