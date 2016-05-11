var Common = {
    showLoading: function ($element, showForControl) {

        if ($element === undefined || $element === null)
            return;

        var isLoadingVisible = $element.find(".loading").is("*");

        if (isLoadingVisible) {
            return;
        }

        if (showForControl) {
            $element.append("<div class='loading control'></div>");
        } else {
            $element.append("<div class='loading'></div>");
        }
    }, hideLoading: function ($element) {

        if ($element === undefined || $element === null)
            return;

        var isLoadingVisible = $element.find(".loading").is("*");

        if (isLoadingVisible) {
            $element.find(".loading").remove();
        }
    }
};