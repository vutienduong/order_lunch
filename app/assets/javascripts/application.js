// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives.js) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker

$(function() { /* to make sure the script runs after page load */

    $('.item-long-content').each(function(event) { /* select all divs with the item class */

        var max_length = 80;
        /* set the max content length before a read more link will be added */

        if ($(this).html().length > max_length) { /* check for content length */

            var short_content = $(this).html().substr(0, max_length);
            /* split the content in two parts */
            var long_content = $(this).html().substr(max_length);

            $(this).html(short_content +
                '<a href="#" class="read_more"><br/>Read More</a>' +
                '<span class="more_text" style="display:none;">' + long_content + '</span>');
            /* Alter the html to allow the read more functionality */

            $(this).find('a.read_more').click(function(event) { /* find the a.read_more element within the new html and bind the following code to it */
                event.preventDefault();
                /* prevent the a from changing the url */
                $(this).hide();
                /* hide the read more button */
                $(this).parents('.item-long-content').find('.more_text').show();
                /* show the .more_text span */
            });
        }
    });
});


function openCity(evt, cityName) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the button that opened the tab
    document.getElementById(cityName).style.display = "block";
    evt.currentTarget.className += " active";
}

function showDishesForRetaurant(evt, restaurantName) {
    var i, tabcontent, tablinks;

    tabcontent = document.getElementsByClassName("restaurant-tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    tablinks = document.getElementsByClassName("restaurant-tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    //document.getElementById(restaurantName).style.display = "block";
    restaurantName.style.display = "block";
    evt.currentTarget.className += " active";

    setCurrentButtonSameAsSelectedName(evt)
}

function setCurrentButtonSameAsSelectedName(evt) {
    try {
        self = $(evt.srcElement)
        caret = "  <span class=\"caret\"></span>"
        if (self.attr('id') == undefined) {
            $('#restautant-dropdown-button').html('[Restaurant] ' + self.text() + caret)
            $('#tag-dropdown-button').html("All tags" + caret)
        }
        else if (self.attr('id').includes('tag_tab_link')) {
            $('#tag-dropdown-button').html('[Tag] ' + self.text() + caret)
        }
    }
    catch (err) {
        console.log(err);
    }
}

function hiddenOtherTags(restaurantName) {
    $("a[id^=\"tag_tab_link_\"]").hide()
    $("a[id^=\"" + restaurantName + "\"]").show()
}

function showPrice(dish) {
    alert(dish)
    var dishPrice = dish.getAttribute("data-price");
    alert("Dish: " + dish.innerHTML + "has price: " + dishPrice + ".");
    return false;
}

function removeDishToday(dish) {
    row = $(dish).closest('div[id^="today_order_"]')
    user_id = $("#today-my-order-user-id").text() || null
    dish_params = {
        dish: {
            order_id: null,
            dish_id: row.data("id"),
            user_id: user_id,
            action: "remove"
        }, select_date: $("#date-select-date").text()
    }
    $.ajax({
        method: 'POST',
        url: '/users/' + user_id + '/save_order',
        data: dish_params,
        dataType: 'json'
    }).done(function (response) {
        console.log(response)
        console.log("Success !!!")
        // Note that if return false at the end, return false is always active before commands in "done" and "always"
        if (response.hasOwnProperty("status") && response["status"] == "ok") {
            total_price_span = $("#total_price_today")
            remain_total = parseInt(total_price_span.text()) - parseInt(row.data("price"))
            total_price_span.text(remain_total)
            //console.log(remain_total)
            row.remove()
            $("#total_price_today").change()
        }
    }).fail(function (jqXHR, textStatus) {
        console.log("Request failed: " + textStatus)
    }).always(function (obj) {
        console.log("Always !!!")
    });
}

function addDishToday2(dish) {
    total_price_span = $("#total_price_today")
    current_total_price = parseInt(total_price_span.text())
    dish_parent = $(dish).closest('div[class=media]')
    dish_price = dish_parent.find(".each-dish-price").text()
    new_total = current_total_price + parseInt(dish_price)
    $("#total-price-warning").text("")
    if (new_total > 80000) {
        if (!confirm("Total price is larger than 80k. Do you want to continue?"))
            return false;
    }

    dish_obj = {}
    dish_obj["id"] = dish_parent.data("id")

    user_id = $("#today-my-order-user-id").text()
    dish_params = {dish: {order_id: null, dish_id: dish_obj["id"], user_id: user_id, action: "add"}, select_date: $("#date-select-date").text()}
    $.ajax({
        method: 'POST',
        url: '/users/' + user_id + '/save_order',
        data: dish_params,
        dataType: 'json'
    }).done(function (response) {
        console.log(response)
        console.log("Success !!!")

        if (response.hasOwnProperty("status") && response["status"] == "ok") {
            var tmpl = $(document.getElementById('template-dish-today').content.cloneNode(true));
            var list = $("#today-my-order-content")

            dish_obj["name"] = dish_parent.find(".each-dish-name").text()
            dish_obj["image_url"] = dish_parent.find(".each-dish-img").attr("src")

            tmpl.find(".each-dish-name").text(dish_obj["name"])
            tmpl.find(".each-dish-price").text(dish_price)
            tmpl.find(".btn btn-warning glyphicon glyphicon-remove").attr("id", "remove_btn_today_order_" + dish_obj["id"])

            tmpl.find("#today-order-template").attr({
                "id": "today_order_" + dish_obj["id"],
                "data-price": dish_price,
                "data-id": dish_obj["id"]
            })
            tmpl.find(".each-dish-img").attr({
                "src": dish_obj["image_url"],
                "alt": dish_obj["name"],
                "data-price": dish_price
            })

            list.append(tmpl)

            total_price_span.text(new_total)
            $("#total_price_today").change()
        }
    }).fail(function (jqXHR, textStatus) {
        console.log("Request failed: " + textStatus)
    }).always(function (obj) {
        console.log("Always !!!")
    });
}

function editOrderNote(note) {
    note = $("#today-order-note-edit").val()
    order_params = {order: {note: note}, select_date: $("#date-select-date").text()}
    $.ajax({
        method: 'POST',
        url: '/users/1/edit_note',
        data: order_params,
        dataType: 'json'
    }).done(function (response) {
        console.log("Success")
        if (response.hasOwnProperty("status") && response["status"] == "ok") {
            $("#today-order-note").text(note)
            showEditNoteResult(true)
            $('#today-order-note-modal').modal('hide')
        }
    }).fail(function () {
        showEditNoteResult(false)
        console.log("Update Note Fail!!!")
    }).always(function () {
        console.log("Update Note Always!!!")
    });
}

function postAjax(order_id, dish_id, user_id, action) {
    dish_params = {dish: {order_id: order_id, dish_id: dish_id, user_id: user_id, action: action}}
    $.ajax({
        method: 'POST',
        url: '/users/' + user_id + '/save_order',
        data: dish_params,
        dataType: 'json'
    }).done(function (response) {
        console.log(response)
        console.log("Success !!!")
        // Note that if return false at the end, return false is always active before commands in "done" and "always"
        if (response.hasOwnProperty("status") && response["status"] == "ok") {
            return true
        }
    }).fail(function (jqXHR, textStatus) {
        console.log("Request failed: " + textStatus)
    }).always(function (obj) {
        console.log("Always !!!")
        return false
    })
    ;
}

function showEditNoteResult(success) {
    if (success) {
        shown_component = $("#edit-note-success-alert")
    } else {
        shown_component = $("#edit-note-fail-alert")
    }
    shown_component.fadeTo(2000, 500).slideUp(500, function () {
        shown_component.slideUp(500);
    });
};

checkTotalPrice = function () {
    console.log(parseInt($("#total_price_today").text()))
    if (parseInt($("#total_price_today").text()) > 80000) {
        $("#total_price_today").addClass("over-budget-highlight")
        $("#total-price-warning").text("Note: TOTAL PRICES IS OVER QUOTA 80.000 VND !!!")
    }
    else {
        $("#total_price_today").removeClass("over-budget-highlight")
        $("#total-price-warning").text("")
    }
}

checkOrderOverBudget = function () {
    a = $(".total-price-order")
    for (var i = 0; i < a.length; i++) {
        b = $(a[i])
        if (parseInt(b.text()) > 80000) {
            b.attr("style", "color: red");
        }
    }
}

testOnclick = function (s) {

    console.log("test on click")
}


trackAllChange = $(function () {
    $("#total_price_today").change(checkTotalPrice)
    checkTotalPrice()

    $('#today-order-note-modal').on('show.bs.modal', function (e) {
        console.log("today-order-note")
        $("#today-order-note-edit").text($("#today-order-note").text())
    })

    $("#edit-note-success-alert").hide();
    $("#edit-note-fail-alert").hide();

    checkOrderOverBudget()
});

twbsPaginationDemo = $(function () {
    $('#pagination-demo').twbsPagination({
        totalPages: 5,
// the current page that show on start
        startPage: 1,

// maximum visible pages
        visiblePages: 5,
        initiateStartPageClick: true,

// template for pagination links
        href: false,

// variable name in href template for page number
        hrefVariable: '{{number}}',

// Text labels
        first: 'First',
        prev: 'Previous',
        next: 'Next',
        last: 'Last',

// carousel-style pagination
        loop: false,

// callback function
        onPageClick: function (event, page) {
            $('.page-active').removeClass('page-active');
            $('#dish-page-' + page).addClass('page-active');
        },

// pagination Classes
        paginationClass: 'pagination',
        nextClass: 'next',
        prevClass: 'prev',
        lastClass: 'last',
        firstClass: 'first',
        pageClass: 'page',
        activeClass: 'active',
        disabledClass: 'disabled'
    });
});

$(function () {
    trackAllChange;
    twbsPaginationDemo;
});


//$(document).ready(trackAllChange);




