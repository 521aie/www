var meta = document.createElement('meta');
meta.setAttribute('name', 'viewport');
meta.setAttribute('content', 'width=device-width, initial-scale=1');
document.getElementsByTagName('head')[0].appendChild(meta);

var style = document.createElement('style');
style.type = 'text/css';style.setAttribute('id', 'Octree');
style.appendChild(document.createTextNode('html body{width:100% !important; min-width:100% !important;} .body { width:100% !important; min-width:100% !important;} .head .inner.wrp { width:100% !important; min-width:100% !important;}'));
document.getElementsByTagName('head')[0].appendChild(style);
