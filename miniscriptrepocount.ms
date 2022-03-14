import "dateTime"

repoName = "miniscript"

repoURL   = "https://github.com/topics/" + repoName + "?o=desc&s=updated"
cacheFile = "/usr/cacheRepoCount" + repoName + ".txt"
cacheTime = 300

httpGetCached = function(url, cacheFile, cacheTime=600, headers=null)
	data = null
	if file.exists(cacheFile) then
		fileTime = dateTime.val(file.info(cacheFile)["date"])
		now = dateTime.val(dateTime.now)
		if fileTime > now - cacheTime then // still fresh
			fh = file.open(cacheFile, "r")
			data = fh.read
			fh.close
		end if
	end if
	if data == null then
		data = http.get(url, headers)
		fh = file.open(cacheFile, "w")
		fh.write data
		fh.close
	end if
	return data
end function

getrepocount = function()
	count = "0"
	repoData = httpGetCached(repoURL, outer.cacheFile, outer.cacheTime)
	pos1 = repoData.indexOf("Here are")
	if pos1 != null then
		chunk = repoData[pos1:pos1 + 128]
		pos2 = chunk.indexOf("public repositories")
		pos3 = chunk.indexOf("matching this topic")
		if (pos2 != null and pos3 != null) then
			found = false
			for i in chunk
				if i.code >= 48 and i.code <= 57 then
					count = count + i
					found = true
				else if found then
					break
				end if
			end for
		end if
	end if
	return val(count)
end function

print "Repo count for " + repoName + " is: " + getrepocount
