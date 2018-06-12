var SearchUserForm = (function () {
    var delayTimer;

    var searchUser = function (text) {
        var searchResultList = $("#order-new-user-result");
        var searchField = $("#order-new-user-search");

        clearTimeout(delayTimer);
        delayTimer = setTimeout(function () {
            console.log("do ajax stuff: " + text);

            $.ajax({
                method: 'POST',
                url: '/users/test_ajax',
                data: {keyword: text},
                dataType: 'json'
            }).done(function (response) {
                console.log(response);
                console.log("Success !!!");
                // Note that if return false at the end, return false is always active before commands in "done" and "always"
                if (response.hasOwnProperty("status") && response["status"] == "ok") {
                    console.log("status ok !!!");
                    users = response["users"];
                    searchResultList.empty();
                    for (var i = 0; i < users.length; i++) {
                        item = $("<a href='#' class='list-group-item'></a>");
                        item.text(users[i]["email"] + " (" + users[i]["username"] + ")");
                        item.data("id", users[i]["id"]);
                        item.data("email", users[i]["email"])
                        item.click(function () {
                            //$(this).siblings().remove();
                            var self = $(this)
                            searchField.val(self.data("email"))
                            searchField.data("id", self.data("id"))
                            self.parent().empty();
                        });
                        searchResultList.append(item);
                    }
                }
            }).fail(function (jqXHR, textStatus) {
                console.log("Request failed: " + textStatus);
            }).always(function (obj) {
                console.log("Always !!!");
            });
        }, 1000); // Will do the ajax stuff after 1000 ms, or 1 s
    }

    function addUser(elem) {
        elem.siblings().remove();
    }

    return {
        searchUser: searchUser,
    }
})();


var NewDishForm = (function () {
    var copyToHiddenField = function () {
        console.log("copy to hidden field");

        user_id = $("#order-new-user-search").data("id") || null;
        $("input[name^=\"order[user_id]\"]").val(user_id);

        dish_list = $("#order-new-list-dish").find("tr")
        dish_ids = [];
        for (var i = 0; i<dish_list.length; i++)
        {
            dish_ids.push(parseInt($(dish_list[i].children[0]).text()))
        }
        $("input[name^=\"order[dishes]\"]").val(dish_ids);
        $("input[name^=\"order[total_price]\"]").val(parseInt($("#order-new-total-price").text()));
    };

    var getDishByDate = function(){
//TODO: convert date to date time, then call
        ChosenDishList(date)
    };
    return {
        copyToHiddenField: copyToHiddenField,
        getDishByDate:getDishByDate,
    }
})();


var pagnitionObj = {

}