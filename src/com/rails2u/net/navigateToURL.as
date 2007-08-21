package com.rails2u.net {
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
    import flash.external.ExternalInterface;

    /*
     * Popup a window through popup blockers.
     * Base by http://d.hatena.ne.jp/os0x/20070812/1186941620
     */
    public function navigateToURL(request:URLRequest, windows:String = ''):void {
        if (windows == '_self') flash.net.navigateToURL(request, '_self');
         
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

        var res:String = ExternalInterface.call(
          'function(url, tg){return window.GeckoActiveXObject ? window.open(url, tg) : null;}', 
          url, windows
        );

        if (!res) {
            var jsURL:String = 'javascript:window.open("' + url + '","' + windows + '");void(0);';
            var req:URLRequest = new URLRequest(jsURL);
            flash.net.navigateToURL(req, '_self');
        }
    }
}
