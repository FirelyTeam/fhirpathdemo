var jqAdapter = {
    http: function (q) {
        var a;
        a = $.ajax({
            type: q.method,
            url: q.url,
            headers: q.headers,
            dataType: "json",
            contentType: "application/json",
            data: q.data || q.params
        });
        if (q.success) {
            a.done(function (data, status, xhr) {
                return q.success(data, status, xhr.getResponseHeader);
            });
        }
        if (q.error) {
            return a.fail(function () {
                return q.error.call(null, arguments);
            });
        }
    }
};