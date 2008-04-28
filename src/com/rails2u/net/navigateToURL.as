package com.rails2u.net {
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
    import flash.external.ExternalInterface;
    import com.rails2u.utils.Browser;

    /*
     * Popup a window through popup blockers.
     * Base by http://d.hatena.ne.jp/os0x/20070812/1186941620
     */
    public function navigateToURL(request:URLRequest, windows:String = ''):void {
        if (windows == '_self') flash.net.navigateToURL(request, '_self');
        var browser:String = Browser.browser;

        if (browser == Browser.FIREFOX || browser == Browser.MSIE) { 
            var url:String = request.url;
            if (request.method == URLRequestMethod.GET) {
                var uv:URLVariables = request.data as URLVariables;
                if (!uv) {
                    uv = new URLVariables;
                    for (var key:String in request.data) {
                        uv[key] = request.data[key];
                    }
                }
                var query:String = uv.toString();
                if (query.length > 0) {
                    url += '?' + query;
                }
            }

            if (browser == Browser.FIREFOX) {
                // FIREFOX
                var res:String = ExternalInterface.call(
                  'function(url, tg){return window.open(url, tg);}', 
                  url, windows
                );
            } else {
                // IE
                var jsURL:String = 'javascript:(function(){window.open("' + url + '", "' + windows + '")})();'
                var req:URLRequest = new URLRequest(jsURL);
                flash.net.navigateToURL(req, '_self');
            }
        } else {
            // Opera, Safari
            flash.net.navigateToURL(request, null);
        }
    }
}
