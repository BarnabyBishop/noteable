(function() {(window.nunjucksPrecompiled = window.nunjucksPrecompiled || {})["error.html"] = (function() {function root(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
env.getTemplate("layout.html", true, function(t_2,parentTemplate) {
if(t_2) { cb(t_2); return; }
for(var t_1 in parentTemplate.blocks) {
context.addBlock(t_1, parentTemplate.blocks[t_1]);
}
output += "\n\n";
parentTemplate.rootRenderFunc(env, context, frame, runtime, cb);
});
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
function b_content(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
output += "\n\t<h1>";
output += runtime.suppressValue(runtime.contextOrFrameLookup(context, frame, "message"), env.autoesc);
output += "</h1>\n\t<h2>";
output += runtime.suppressValue(runtime.memberLookup((runtime.contextOrFrameLookup(context, frame, "error")),"status", env.autoesc), env.autoesc);
output += "</h2>\n\t<pre>";
output += runtime.suppressValue(runtime.memberLookup((runtime.contextOrFrameLookup(context, frame, "error")),"stack", env.autoesc), env.autoesc);
output += "</pre>\n";
cb(null, output);
;
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
return {
b_content: b_content,
root: root
};
})();
})();
(function() {(window.nunjucksPrecompiled = window.nunjucksPrecompiled || {})["index.html"] = (function() {function root(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
env.getTemplate("layout.html", true, function(t_2,parentTemplate) {
if(t_2) { cb(t_2); return; }
for(var t_1 in parentTemplate.blocks) {
context.addBlock(t_1, parentTemplate.blocks[t_1]);
}
output += "\r\n\r\n";
parentTemplate.rootRenderFunc(env, context, frame, runtime, cb);
});
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
function b_content(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
output += "\r\n\t<div class=\"notelist-container\">\r\n\t\t<div class=\"folderlist\">\r\n\t\t\t<button class=\"folders\">\r\n\t\t\t\t<i class=\"icon ion-ios7-bookmarks-outline\"></i>\r\n\t\t\t\t<span class=\"currentfolder\" data-current-path=\"\"></span>\r\n\t\t\t</button>\r\n\t\t\t<div class=\"panel\">\r\n\t\t\t\t<button class=\"icon ion-ios7-plus-empty newfolder\"></button>\r\n\t\t\t\t<input type=\"text\" placeholder=\"New Folder\" class=\"foldername textbox\">\r\n\t\t\t\t<button class=\"confirmfolder icon ion-ios7-checkmark\"></button>\r\n\t\t\t</div>\r\n\t\t</div>\r\n\t\t<div class=\"notelist\"></div>\r\n\t</div>\r\n\r\n\t<div class=\"note-container\">\r\n\t\t<button class=\"icon ion-ios7-plus-empty newnote\"></button>\r\n\t\t<button class=\"icon ion-ios7-trash-outline deletenote\"></button>\r\n\t\t<div class=\"note\">\r\n\t\t\t<button class=\"startlist icon ion-clipboard\"></button>\r\n\t\t\t<input type=\"text\" class=\"title\" placeholder=\"Title\" data-field=\"title\">\r\n\t\t\t<div class=\"list\"></div>\r\n\t\t\t<textarea name=\"\" id=\"\" cols=\"30\" rows=\"10\" class=\"text\" placeholder=\"Note\" data-field=\"text\"></textarea>\r\n\t\t</div>\r\n\t</div>\r\n\r\n\t<script src=\"/scripts/uuid.min.js\"></script>\r\n\t<script src=\"/scripts/jquery-2.1.1.min.js\"></script>\r\n\t<script src=\"/scripts/nunjucks-slim.min.js\"></script>\r\n\t<script src=\"/scripts/templates.js\"></script>\r\n\t<script src=\"/scripts/index.js\"></script>\r\n\r\n\r\n";
cb(null, output);
;
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
return {
b_content: b_content,
root: root
};
})();
})();
(function() {(window.nunjucksPrecompiled = window.nunjucksPrecompiled || {})["layout.html"] = (function() {function root(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
output += "<!DOCTYPE html>\r\n<html lang=\"en\">\r\n<head>\r\n\t<meta charset=\"UTF-8\">\r\n\t<title>Noteable</title>\r\n\t<meta charset=\"utf-8\" />\r\n\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>\r\n\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />\r\n\r\n\t<link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css' />\r\n\t<link rel='stylesheet' href='/styles/normalise.css' />\r\n\t<link rel='stylesheet' href='/styles/style.css' />\r\n\t<link rel='stylesheet' href='/fonts/ionicons.min.css' />\r\n</head>\r\n<body>\r\n\t";
context.getBlock("content")(env, context, frame, runtime, function(t_2,t_1) {
if(t_2) { cb(t_2); return; }
output += t_1;
output += "\r\n</body>\r\n</html>";
cb(null, output);
});
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
function b_content(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
cb(null, output);
;
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
return {
b_content: b_content,
root: root
};
})();
})();
(function() {(window.nunjucksPrecompiled = window.nunjucksPrecompiled || {})["list.html"] = (function() {function root(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
context.getBlock("content")(env, context, frame, runtime, function(t_2,t_1) {
if(t_2) { cb(t_2); return; }
output += t_1;
cb(null, output);
});
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
function b_content(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
output += "\r\n\t";
frame = frame.push();
var t_5 = runtime.contextOrFrameLookup(context, frame, "list");
if(t_5) {var t_4 = t_5.length;
for(var t_3=0; t_3 < t_5.length; t_3++) {
var t_6 = t_5[t_3];
frame.set("item", t_6);
frame.set("loop.index", t_3 + 1);
frame.set("loop.index0", t_3);
frame.set("loop.revindex", t_4 - t_3);
frame.set("loop.revindex0", t_4 - t_3 - 1);
frame.set("loop.first", t_3 === 0);
frame.set("loop.last", t_3 === t_4 - 1);
frame.set("loop.length", t_4);
output += "\r\n\t\t";
context.getBlock("listitem")(env, context, frame, runtime, function(t_8,t_7) {
if(t_8) { cb(t_8); return; }
output += t_7;
output += "\r\n\t";
});
}
}
frame = frame.pop();
output += "\r\n\t";
context.getBlock("listitem")(env, context, frame, runtime, function(t_10,t_9) {
if(t_10) { cb(t_10); return; }
output += t_9;
output += "\r\n";
cb(null, output);
});
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
function b_listitem(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
output += "\r\n\t\t";
cb(null, output);
;
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
function b_listitem(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
output += "\r\n\t";
cb(null, output);
;
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
return {
b_content: b_content,
b_listitem: b_listitem,
b_listitem: b_listitem,
root: root
};
})();
})();
(function() {(window.nunjucksPrecompiled = window.nunjucksPrecompiled || {})["listitem.html"] = (function() {function root(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
env.getTemplate("list.html", true, function(t_2,parentTemplate) {
if(t_2) { cb(t_2); return; }
for(var t_1 in parentTemplate.blocks) {
context.addBlock(t_1, parentTemplate.blocks[t_1]);
}
output += "\r\n";
parentTemplate.rootRenderFunc(env, context, frame, runtime, cb);
});
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
function b_listitem(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
output += "\r\n\t<div class=\"listitem ";
if(runtime.memberLookup((runtime.contextOrFrameLookup(context, frame, "item")),"checked", env.autoesc)) {
output += "checked";
;
}
output += "\" data-index=\"";
output += runtime.suppressValue(runtime.memberLookup((runtime.contextOrFrameLookup(context, frame, "loop")),"index0", env.autoesc), env.autoesc);
output += "\">\r\n\t\t<button class=\"listcheckbox icon ";
if(runtime.memberLookup((runtime.contextOrFrameLookup(context, frame, "item")),"checked", env.autoesc)) {
output += "ion-ios7-checkmark-outline";
;
}
else {
output += "ion-ios7-circle-outline";
;
}
output += "\"></button>\r\n\t\t<div contenteditable=\"true\" class=\"listtext\">";
output += runtime.suppressValue(runtime.memberLookup((runtime.contextOrFrameLookup(context, frame, "item")),"text", env.autoesc), env.autoesc);
output += "</div>\r\n\t\t<button class=\"listmoveup icon ion-ios7-arrow-up\"></button>\r\n\t\t<button class=\"listmovedown icon ion-ios7-arrow-down\"></button>\r\n\t\t<button class=\"listclose icon ion-ios7-close-empty\"></button>\r\n\t</div>\r\n";
cb(null, output);
;
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
return {
b_listitem: b_listitem,
root: root
};
})();
})();
(function() {(window.nunjucksPrecompiled = window.nunjucksPrecompiled || {})["login.html"] = (function() {function root(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
env.getTemplate("layout.html", true, function(t_2,parentTemplate) {
if(t_2) { cb(t_2); return; }
for(var t_1 in parentTemplate.blocks) {
context.addBlock(t_1, parentTemplate.blocks[t_1]);
}
output += "\r\n\r\n";
parentTemplate.rootRenderFunc(env, context, frame, runtime, cb);
});
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
function b_content(env, context, frame, runtime, cb) {
var lineno = null;
var colno = null;
var output = "";
try {
output += "\r\n\t<div class=\"login-container\">\r\n\t\t";
if(runtime.contextOrFrameLookup(context, frame, "message")) {
output += "\r\n\t\t\t<div>";
output += runtime.suppressValue(runtime.contextOrFrameLookup(context, frame, "message"), env.autoesc);
output += "</div>\r\n\t\t";
;
}
output += "\r\n\t\t<form method='post'>\r\n\r\n\t\t\t<input type='email' name='email' placeholder='Email' required class=\"textbox\" />\r\n\t\t\t<input type='password' name='password' placeholder='password' required class=\"textbox\" />\r\n\t\t\t<button type=\"submit\" class=\"button\">Login</button>\r\n\t\t</form>\r\n\t</div>\r\n";
cb(null, output);
;
} catch (e) {
  cb(runtime.handleError(e, lineno, colno));
}
}
return {
b_content: b_content,
root: root
};
})();
})();
