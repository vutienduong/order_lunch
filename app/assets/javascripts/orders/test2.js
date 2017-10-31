function Fruit(theColor, theSweetness, theFruitName, theNativeToLand) {
    this.color = theColor;
    this.sweetness = theSweetness;
    this.fruitName = theFruitName;
    this.nativeToLand = theNativeToLand;

    this.showName = function () {
        console.log("This is a " + this.fruitName);
    }

    this.nativeTo = function () {
        this.nativeToLand.forEach(function (eachCountry) {
            console.log("Grown in:" + eachCountry);
        });
    }
}

function ChosenDishList(date) {
    this.setDate = function () {
        date_select = $("select[id^=order_date]");
        year = $(date_select[0]).val();
        month = $(date_select[1]).val();
        day = $(date_select[2]).val();
        return {year: year, month: month, day: day}
    };

    this.date = this.setDate();


    this.list_pages = $("#order-new-wrap-dish-pagination")
    this.pagnition = this.list_pages.find("#pagination-demo")

    //debugger
    this.createListPage = function () {
        console.log("create List Page", date);
        self = this;
        $.ajax({
            method: 'POST',
            url: '/admin/orders/ajax_get_dishes_by_date',
            data: {date: self.date},
            dataType: 'json'
        }).done(function (response) {
            console.log(response, "Success !!!");
            self.list_pages.find("div[class^=page]").remove();

            if (response["status"] == "ok") {
                if (!self.pagnition.is(":visible")) {
                    self.pagnition.show();
                }
                console.log("status ok !!!");
                page_class = "page";
                slice_dishes = response["slice_dishes"];
                for (var i = 1; i <= slice_dishes.length; i++) {

                    page = $("<div></div>").addClass(page_class).attr("id", "dish-page-" + i)
                    if (i == 1) {
                        page.addClass("page-active");
                    }
                    table = ChosenDish(slice_dishes[i - 1])
                    page.append(table)
                    self.list_pages.prepend(page)
                }
                //self.list_pages.append(Pagination(slice_dishes.length))
            }
            else {
                console.log("status fail !!!");
                self.pagnition.hide();
                //self.list_pages.append("<h2>No dish</h2>")
            }
        }).fail(function (jqXHR, textStatus) {
            console.log("Request failed: " + textStatus);
        }).always(function (obj) {
            console.log("Always !!!");
        });
    };
    return this;
}

function ChosenDish(dishes) {
    table = $("<table></table>").addClass("table");
    for (var i = 0; i < dishes.length; i++) {
        dish = dishes[i]
        tr = $("<tr><td></td><td></td></tr>")
        a = $("<a href='#' onclick=\"ChosenDishTr.addDish(this)\" >add</a>").data({dish: dish})
        $(tr.children()[0]).text(dish["name"])
        $(tr.children()[1]).append(a)
        table.append(tr)
    }
    return table;
}

function Pagination(num_of_page) {
    this.id = "pagination-demo";
    this.class = "pagination-lg pull-center pagination"
    this.num_of_page = num_of_page

    this.ul = function () {
        ul = $("<ul></ul>").addClass(this.class).attr("id", this.id);
        ul.append(PageLink("first disabled", "First"));
        ul.append(PageLink("prev disabled", "Previous"));
        ul.append(PageLink("page-active", 1));

        for (var i = 2; i <= this.num_of_page; i++) {
            ul.append(PageLink("page", i));
        }

        ul.append(PageLink("next", "Next"));
        ul.append(PageLink("last", "Last"))
        return ul
    }
    return this.ul()
}

function PageLink(class_name, value) {
    li = $("<li></li>").addClass(class_name);
    a = $("<a></a>").attr("href", "#").addClass("page-link").text(value.toString());
    return li.append(a)
}