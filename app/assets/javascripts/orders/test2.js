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

function ChosenDishList(date){
    this.date = date
    this.list_pages = $("#order-new-wrap-dish-pagination")
    this.createListPage = function(){
        $.ajax({
            method: 'POST',
            url: '/orders/ajax_get_dishes_by_date',
            data: {date: this.date},
            dataType: 'json'
        }).done(function (response) {
            console.log(response, "Success !!!");
            debugger;

            if (response["status"] == "ok") {
                console.log("status ok !!!");
                this.list_pages.empty();
                slice_dishes = response["slice_dishes"];
                for(var i = 0; i< slice_dishes.length; i++)
                {
                    page = $("<div></div>").addClass("page").attr("id", "dish-page-"+i)
                    table = ChosenDish(slice_dishes[i])
                    page.append(table)
                    this.list_pages.append(page)
                }
            }
            else {
                console.log("status fail !!!");
                this.list_pages.empty();
                this.list_pages.append("<h2>FAIL ajax</h2>")
            }
        }).fail(function (jqXHR, textStatus) {
            console.log("Request failed: " + textStatus);
        }).always(function (obj) {
            console.log("Always !!!");
        });
    }
}

function ChosenDish(dishes){
    table = $("<table></table>").addClass("table");
    for(var i = 0; i< dishes.length; i++)
    {
        dish = dishes[i]
        tr = $("<tr><td></td><td></td></tr>")
        a = $("<a href='#'>add</a>").data({dish: dish}).click("ChosenDishTr.addDish(this)")
        $(tr.children()[0]).text(dish["name"])
        $(tr.children()[1]).append(a)
        table.append(tr)
    }
    return table;
}