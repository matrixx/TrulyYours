.pragma library

var ambiences = []
var tags = []
var tagCounts = []
var filteredCnt = 0;

function fetchAmbiences(tagMgr, authkey)
{
    var xhr = new XMLHttpRequest
    var query = "http://www.jollawalls.com/api/media"
    xhr.open("GET", query);
    xhr.setRequestHeader('auth_key', authkey);

    xhr.onreadystatechange = function()
    {
        if (xhr.readyState === XMLHttpRequest.DONE)
        {
            var results = JSON.parse(xhr.responseText)
            for (var i in results)
            {
                if (results[i].pic_url)
                {
                    var reduced = results[i].pic_url.replace(/\\/gi,'');
                    var fullUrl = "http://www.jollawalls.com/content/uploads/images/" + reduced;
                    saveTags(results[i].tags);
                    results[i].fullUri = fullUrl;
                    results[i].fileName = getFileName(results[i].slug, results[i].pic_url)
                    results[i].activated = false;
                }
            }
            for (var j = results.length - 1; j > -1; j--)
            {
                ambiences.push(results[j]);
            }
            tagMgr.sortAndSaveTags(tags, tagCounts);
        }
    }
    xhr.send();
}

function fillModel(model, filter)
{
    model.clear();
    filteredCnt = 0;
    for (var i in ambiences)
    {
        if (hasTag(filter, ambiences[i].tags) || (filter === ""))
        {
            model.append(ambiences[i]);
            filteredCnt++;
        }
    }
    console.debug("set ambience count: " + filteredCnt);
}

function filteredCount()
{
    return filteredCnt;
}

function getFileName(baseName, picUrl)
{
    if (picUrl.indexOf(".jpg") > -1)
    {
        baseName += ".jpg";
    }
    else if (picUrl.indexOf(".jpeg") > -1)
    {
        baseName += ".jpeg";
    }
    else
    {
        baseName += ".png";
    }
    return baseName;
}

function saveTags(tagString)
{
    var tagList = tagString.split(",");
    for (var i in tagList)
    {
        if (tagList[i] === "")
        {
            break;
        }

        var index = tags.indexOf(tagList[i].toLowerCase());
        if (index > -1)
        {
            tagCounts[index] += 1;
        }
        else
        {
            tags.push(tagList[i]);
            tagCounts.push(1);
        }
    }
}

function hasTag(tag, tagString)
{
    var tagList = tagString.split(",");
    for (var i in tagList)
    {
        if (tagList[i].toLowerCase() === tag)
        {
            return true;
        }
    }
    return false;
}

function fetchComments(model, id, loading, authkey)
{
    model.clear();
    loading = true;
    var xhr = new XMLHttpRequest
    var query = "http://www.jollawalls.com/api/comments/" + id;
    xhr.open("GET", query);
    xhr.setRequestHeader('auth_key', authkey);

    xhr.onreadystatechange = function()
    {
        if (xhr.readyState === XMLHttpRequest.DONE)
        {
            var results = JSON.parse(xhr.responseText)
            for (var i in results)
            {
                model.append(results[i]);
            }
            loading = false;
        }
    }
    xhr.send();
}
