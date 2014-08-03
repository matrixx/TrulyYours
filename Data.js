.pragma library

var ambiences = []
var tags = []
var tagCounts = []

function getAmbiences(model)
{
    var xhr = new XMLHttpRequest
    var query = "http://www.jollawalls.com/api/media"
    xhr.open("GET", query);
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
            model.append(ambiences);
        }
    }
    xhr.send();
}

function getFileName(baseName, picUrl)
{
    if (picUrl.indexOf(".jpg") > -1)
    {
        baseName += ".jpg";
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
        var index = tags.indexOf(tagList[i]);
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
