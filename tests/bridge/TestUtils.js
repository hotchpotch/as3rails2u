if (typeof console == 'undefined') {
    console = {};
    if (typeof(external) != 'undefined' && typeof(external.consolelog) == 'unknown') {
        console.log = function(arg) {
            external.consolelog(arg);
        }
    } else {
        console.log = function() {};
    }
}
log = console.log;

Function.prototype.later = function(ms) {
    // from http://la.ma.la/blog/diary_200507302354.htm
    var self = this;
    var func = function(){
        var arg = func.arguments;
        var apply_to = this;
        var later_func = function(){
            self.apply(apply_to, arg)
        };
        setTimeout(later_func,ms);
    };
    return func;
}

function testName(str) {
    var result =  document.getElementById('result');
    _sep = document.createElement('ul');
    var _h2 = document.createElement('h2');
    _h2.innerHTML = str;
    _sep.appendChild(_h2);
    result.appendChild(_sep);
}

function addResult(str, type) {
    var result =  document.getElementById('result');
    if (typeof _sep == 'undefined') {
        _sep = document.createElement('ul');
        result.appendChild(_sep);
    }

    var res = document.createElement('li');
    res.innerHTML = str;
    if (type == 'success') {
        res.style.backgroundColor = '#D8FFE1';
    } else if (type == 'error') {
        res.style.backgroundColor = '#FFD8D8';
    }
    _sep.appendChild(res);
}

function ok(res, commnet) {
    if (res) {
        addResult('success: ' + commnet, 'success');
    } else {
        addResult('error: ' + commnet, 'error');
    }
}

function is(a, b, commnet) {
    if (a == b) {
        addResult('success: ' + commnet, 'success');
    } else {
        addResult('error: ' + commnet, 'error');
    }
}

function testFunc(func, commnet) {
    ok(func.call(func), commnet);
}
