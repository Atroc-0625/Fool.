function replaceAll(str, find, replace) {
    return str.replace(new RegExp(find, 'g'), replace);
}

function dec2hex(dec, padding){
  return parseInt(dec, 10).toString(16).padStart(padding, '0');
}

function utf8StringToUtf16String(str) {
  var utf16 = [];
  for (var i=0, strLen=str.length; i < strLen; i++) {
    utf16.push('\\\\u')
    utf16.push(dec2hex(str.charCodeAt(i), 4));
  }
  return utf16.join('');
}


var keywords = [''];

var result = body;

keywords.forEach(function(k) {
  result = replaceAll(result, k, '');
  result = replaceAll(result, utf8StringToUtf16String(k), "\u55b5\u55b5\u55b5");  
});

result;
