var modalMain = new BSModal("#homepage-info-modal");

function BSModal(selector) {
    this.selector = selector;

    this.modal = function (attrs) {
        $(this.selector).modal(attrs);
    }

    this.setTitle = function (value) {
        $(this.selector + " .modal-title").text(value);
    }

    this.clearTitle = function () {
        this.setTitle("");
    }

    this.setBody = function (value) {
        $(this.selector + " .modal-body").text(value);
    }

    this.clearBody = function () {
        this.setBody("");
    }

    this.show = function() {
        this.modal("show");
    }

    this.hide = function () {
        this.modal("hide");
    }

    this.toggle = function () {
        this.modal("toggle");
    }

    this.isShown = function () {
        return $(this.selector).hasClass("in");
    }
}
