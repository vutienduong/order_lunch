// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets

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

function showPrice(dish) {
    alert(dish)
    var dishPrice = dish.getAttribute("data-price");
    alert("Dish: " + dish.innerHTML + "has price: " + dishPrice + ".");
    return false;
}

function removeDishToday(dish) {
    row = $(dish).closest('div[class^="row"]')

    total_price_span = $("#total_price_today")
    remain_total = parseInt(total_price_span.text()) - parseInt(row.data("price"))
    total_price_span.text(remain_total)
    //console.log(remain_total)
    row.remove()
    $("#total_price_today").change()
    dish_id = row.find(".each-dish-id").text()
    postAjax(null, dish_id, null, "remove")
}

function addDishToday(dish) {

    // Way 1: use template
    //var tmpl = $("#today-order-template").clone() //clone follow jQuery

    // check if total larger than 80k, generate alert
    total_price_span = $("#total_price_today")
    current_total_price = parseInt(total_price_span.text())
    dish_parent = $(dish).closest('div[class^=col-xs-6]')
    dish_price = dish_parent.find(".each-dish-price").text()
    new_total = current_total_price + parseInt(dish_price)
    $("#total-price-warning").text("")
    if (new_total > 80000) {
        if (!confirm("Total price is larger than 80k. Do you want to continue?"))
            return false;
    }

    var tmpl = $(document.getElementById('template-dish-today').content.cloneNode(true));
    var list = $("#today-my-order-content")


    dish_obj = {}

    dish_obj["name"] = dish_parent.find(".each-dish-name").text()
    dish_obj["id"] = dish_parent.find(".each-dish-id").text()
    dish_obj["image_url"] = dish_parent.find(".each-dish-img").attr("src")

    tmpl.find(".each-dish-name").text(dish_obj["name"])
    tmpl.find(".each-dish-price").text(dish_price)
    tmpl.find(".each-dish-id").text(dish_obj["id"])
    tmpl.find(".btn btn-warning glyphicon glyphicon-remove").attr("id", "remove_btn_today_order_" + dish_obj["id"])


    tmpl.find("#today-order-template").attr({"id": "today_order_" + dish_obj["id"], "data-price": dish_price})
    tmpl.find(".each-dish-img").attr({"src": dish_obj["image_url"], "alt": dish_obj["name"], "data-price": dish_price})

    list.append(tmpl)

    // add price to total
    total_price_span.text(new_total)
    $("#total_price_today").change()
    user_id = $("#today-my-order-user-id").text()
    // Way 2: use clone from dish_parent
    postAjax(null, dish_obj["id"], user_id, "add")
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
    }).fail(function (jqXHR, textStatus) {
        console.log("Request failed: " + textStatus)
    }).always(function (obj) {
        console.log("Always !!!")
    })
    ;
}

jQuery(function () {
    $("#total_price_today").change(function () {
        console.log("total-price-today change")
        if (parseInt($(this).text()) > 80000) {
            $("#total-price-warning").text("Note: TOTAL PRICES IS OVER QUOTA 80.000 VND !!!")
        }
        else {
            $("#total-price-warning").text("")
        }
    });

    $("#total_price_today").click(function () {
        $(".target").change();
    });
});
