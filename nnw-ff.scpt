set theFriendFeedUser to "YOURUSERNAME"
set theFriendFeedSecretKey to "YOURSECRETKEY" -- get it at https://friendfeed.com/account/api 
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