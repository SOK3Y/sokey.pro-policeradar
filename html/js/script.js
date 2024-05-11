$(function () {
    window.addEventListener("message", function(event) {
        var item = event.data
        if (item.type === "toggle") {
            if (item.status) {
                display(true)
            } else {
                display(false)
            }
        }
        switch (item.type) {
            case "toggle":
                if (item.status) {
                    display(true)
                } else {
                    display(false)
                }
                break;
            case "update":
                setValue("#frontPlate", item.frontPlate, "Brak")
                setValue("#frontSpeed", item.frontSpeed + " mph", "0 mph")
                setValue("#backPlate", item.backPlate, "Brak")
                setValue("#backSpeed", item.backSpeed + " mph", "0 mph")
            break;
        }
    })
})

function setValue(parameter, text, ifnot) {
    if (text) {
        $(parameter).html(text)
    } else {
        $(parameter).html(ifnot)
    }
}

function display(bool) {
    if (bool) {
        $(".radarContainer").fadeIn(400);
    } else {
        $(".radarContainer").fadeOut(400);
    }
}