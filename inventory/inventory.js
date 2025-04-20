$(function () {
    window.addEventListener('message', function(event) {

        let inventory    = event.data;
        let itemsPlayer  = inventory.ItemsPlayer;
        let cash         = inventory.cash;
        let sizemax      = inventory.sizemax;
        let golds        = inventory.golds;
        let xp           = inventory.xp;

        if(inventory.type == "inventory_ui"){
            if (inventory.type == "inventory_ui" && inventory.status) {
                document.getElementById("inventory_ui").style.display = "block";

                $("#inventory_ui").show();
                $(".item_name_top").html('');
                $(".item_description").html('');
                $(".poids").html('');
                $(".bonus").html('');
                $(".bonus2").html('');
                $("#cashinv").html('');
                $("#cashinv").html(parseFloat(cash).toFixed(2));
                $("#goldsinv").html('');
                $("#goldsinv").html(golds);
                $("#sizemax").html('');
                $("#sizemax").html(sizemax);
                $("#xpbar").html('');
                $("#xpbar").html('You have '+xp+' XP');

                let cliked        = category("all");
                $('.filter').unbind('click').mousedown(function(event){
                    let click        =  $(this).data('category');
                    category(click)
                    $(".item_name_top").html('');
                    $(".item_description").html('');
                });

                function category(click){

                let cliked      = click
                let weightbase  = 0;
                let i           = 0;

                // ALL ITEMS
                if(cliked == "all"){
                    HideAll();
                    for (itemSingle in itemsPlayer) {
                        if(itemsPlayer[itemSingle].amount >= 1){
                            i++;
                            weightbase += parseFloat(itemsPlayer[itemSingle].total);
                            $("#content_user").append(`
                                <div class="col-lg-3 my-2">
                                    <div class="case_item item_`+itemsPlayer[itemSingle].rare+`"
                                        data-cat="`+itemsPlayer[itemSingle].type_item+`"
                                        data-droped="`+itemsPlayer[itemSingle].droped+`" 
                                        data-bonus="`+itemsPlayer[itemSingle].bonus+`" 
                                        data-bonus2="`+itemsPlayer[itemSingle].bonus2+`"
                                        data-quantity="`+itemsPlayer[itemSingle].amount+`" 
                                        data-poids="`+itemsPlayer[itemSingle].total+`" 
                                        data-name="`+itemsPlayer[itemSingle].name+`" 
                                        data-label="`+itemsPlayer[itemSingle].label+`" 
                                        data-desc="`+itemsPlayer[itemSingle].description+`" 
                                        style="background-image: url('`+itemsPlayer[itemSingle].img+`');">
                                        <span class="stock_item">`+itemsPlayer[itemSingle].amount+`</span>
                                    </div>
                                </div>
                            `);
                        }
                    }
                }

                // Provisions
                if(cliked == "provisions"){
                    HideAll();
                    for (itemSingle in itemsPlayer) {
                        if(itemsPlayer[itemSingle].amount >= 1 && itemsPlayer[itemSingle].type_item == "eat" 
                        || itemsPlayer[itemSingle].type_item == "drink"){
                            i++;
                            weightbase += parseFloat(itemsPlayer[itemSingle].total);
                            $("#content_user2").append(`
                                <div class="col-lg-3 my-2">
                                    <div class="case_item item_`+itemsPlayer[itemSingle].rare+`"
                                        data-cat="`+itemsPlayer[itemSingle].type_item+`"
                                        data-droped="`+itemsPlayer[itemSingle].droped+`" 
                                        data-bonus="`+itemsPlayer[itemSingle].bonus+`" 
                                        data-bonus2="`+itemsPlayer[itemSingle].bonus2+`"
                                        data-quantity="`+itemsPlayer[itemSingle].amount+`" 
                                        data-poids="`+itemsPlayer[itemSingle].total+`" 
                                        data-name="`+itemsPlayer[itemSingle].name+`" 
                                        data-label="`+itemsPlayer[itemSingle].label+`" 
                                        data-desc="`+itemsPlayer[itemSingle].description+`" 
                                        style="background-image: url('`+itemsPlayer[itemSingle].img+`');">
                                        <span class="stock_item">`+itemsPlayer[itemSingle].amount+`</span>
                                    </div>
                                </div>
                            `);
                        }
                    }
                }

                // HP
                if(cliked == "hp"){
                    HideAll();
                    for (itemSingle in itemsPlayer) {
                        if(itemsPlayer[itemSingle].amount >= 1 && itemsPlayer[itemSingle].type_item == "health" || itemsPlayer[itemSingle].type_item == "potion"){
                            i++;
                            weightbase += parseFloat(itemsPlayer[itemSingle].total);
                            $("#content_user5").append(`
                                <div class="col-lg-3 my-2">
                                    <div class="case_item item_`+itemsPlayer[itemSingle].rare+`"
                                        data-cat="`+itemsPlayer[itemSingle].type_item+`"
                                        data-droped="`+itemsPlayer[itemSingle].droped+`" 
                                        data-bonus="`+itemsPlayer[itemSingle].bonus+`" 
                                        data-bonus2="`+itemsPlayer[itemSingle].bonus2+`"
                                        data-quantity="`+itemsPlayer[itemSingle].amount+`" 
                                        data-poids="`+itemsPlayer[itemSingle].total+`" 
                                        data-name="`+itemsPlayer[itemSingle].name+`" 
                                        data-label="`+itemsPlayer[itemSingle].label+`" 
                                        data-desc="`+itemsPlayer[itemSingle].description+`" 
                                        style="background-image: url('`+itemsPlayer[itemSingle].img+`');">
                                        <span class="stock_item">`+itemsPlayer[itemSingle].amount+`</span>
                                    </div>
                                </div>
                            `);
                        }
                    }
                }

                // Weapons & Ammos
                if(cliked == "weapons"){
                    HideAll();
                    for (itemSingle in itemsPlayer) {
                        if(itemsPlayer[itemSingle].amount >= 1 && itemsPlayer[itemSingle].type_item == "weapon" 
                        || itemsPlayer[itemSingle].type_item == "weaponthrow" || itemsPlayer[itemSingle].type_item == "ammo"){
                            i++;
                            weightbase += parseFloat(itemsPlayer[itemSingle].total);
                            $("#content_user3").append(`
                                <div class="col-lg-3 my-2">
                                    <div class="case_item item_`+itemsPlayer[itemSingle].rare+`"
                                        data-cat="`+itemsPlayer[itemSingle].type_item+`"
                                        data-droped="`+itemsPlayer[itemSingle].droped+`" 
                                        data-bonus="`+itemsPlayer[itemSingle].bonus+`" 
                                        data-bonus2="`+itemsPlayer[itemSingle].bonus2+`"
                                        data-quantity="`+itemsPlayer[itemSingle].amount+`" 
                                        data-poids="`+itemsPlayer[itemSingle].total+`" 
                                        data-name="`+itemsPlayer[itemSingle].name+`" 
                                        data-label="`+itemsPlayer[itemSingle].label+`" 
                                        data-desc="`+itemsPlayer[itemSingle].description+`" 
                                        style="background-image: url('`+itemsPlayer[itemSingle].img+`');">
                                        <span class="stock_item">`+itemsPlayer[itemSingle].amount+`</span>
                                    </div>
                                </div>
                            `);
                        }
                    }
                }

                // Items classic
                if(cliked == "standard"){
                    HideAll();
                    for (itemSingle in itemsPlayer) {
                        if(itemsPlayer[itemSingle].amount >= 1 && itemsPlayer[itemSingle].type_item == "standard"){
                            i++;
                            weightbase += parseFloat(itemsPlayer[itemSingle].total);
                            $("#content_user4").append(`
                                <div class="col-lg-3 my-2">
                                    <div class="case_item item_`+itemsPlayer[itemSingle].rare+`"
                                        data-cat="`+itemsPlayer[itemSingle].type_item+`"
                                        data-droped="`+itemsPlayer[itemSingle].droped+`" 
                                        data-bonus="`+itemsPlayer[itemSingle].bonus+`" 
                                        data-bonus2="`+itemsPlayer[itemSingle].bonus2+`"
                                        data-quantity="`+itemsPlayer[itemSingle].amount+`" 
                                        data-poids="`+itemsPlayer[itemSingle].total+`" 
                                        data-name="`+itemsPlayer[itemSingle].name+`" 
                                        data-label="`+itemsPlayer[itemSingle].label+`" 
                                        data-desc="`+itemsPlayer[itemSingle].description+`" 
                                        style="background-image: url('`+itemsPlayer[itemSingle].img+`');">
                                        <span class="stock_item">`+itemsPlayer[itemSingle].amount+`</span>
                                    </div>
                                </div>
                            `);
                        }
                    }
                }

                $("#weightbase").html('');
                $("#weightbase").html(weightbase.toFixed(2));

                $('.case_item').unbind('click').mousedown(function(event){
                    switch (event.which) {
                        case 1:
                            let itemname      = $(this).data('name');
                                $.post(`https://${GetParentResourceName()}/useitem`, JSON.stringify(
                                    {
                                        itemname    : itemname
                                    }
                                ));
                            clear()
                            return;
                            break;
                        case 2:
                            let droped          = $(this).data('droped');
                            if(droped == 1){
                                var modal = document.getElementById("myModal");
                                modal.style.display = "block";
                                let quantitytotal   = $(this).data('quantity');
                                let nameitem        = $(this).data('name');
                                let itemlabel       = $(this).data('label');
                                let weightotal      = $(this).data('poids');
                                $("#quantityitems").val();
                                $("#quantityitems").val(quantitytotal);
                                $("#quantitychecker").val();
                                $("#quantitychecker").val(quantitytotal);
                                $("#weightotal").val();
                                $("#weightotal").val(weightotal);
                                $("#name").val();
                                $("#name").val(nameitem);
                                $("#label").val();
                                $("#label").val(itemlabel);
                            }else{
                                $.post(`https://${GetParentResourceName()}/errordrop`, JSON.stringify({}));
                            }
                            break;
                        case 3:
                            let bonus      = $(this).data('bonus');
                            let bonus2     = $(this).data('bonus2');
                            let label      = $(this).data('label');
                            let desc       = $(this).data('desc');
                            let poids      = $(this).data('poids');
                            let cat        = $(this).data('cat');

                            $(".poids").html('');
                            $(".poids").html(parseFloat(poids).toFixed(2)+" KG");

                            $(".bonus").html('');
                            $(".bonus2").html('');

                            if(cat == "eat"){
                                $(".bonus").html("+"+bonus+" EAT");
                                $(".bonus2").html("+"+bonus2+" DRINK");
                            }
                            if(cat == "drink"){
                                $(".bonus").html("+"+bonus+" DRINK");
                                $(".bonus2").html("+"+bonus2+" EAT");
                            }
                            if(cat == "health"){
                                $(".bonus").html("+"+bonus+" HP");
                            }

                            $(".item_name_top").html('');
                            $(".item_description").html('');
                            $(".item_name_top").html("<p class='animate__animated animate__fadeIn m-0'>"+label+"</p>");
                            $(".item_description").html("<p class='animate__animated animate__fadeIn animate__delay-1s m-0'>"+desc+"</p>");
                            break;
                        default:
                        break;
                    }
                });

                $('.drop').unbind('click').click(function(){
                    var modal       = document.getElementById("myModal");
                    let dropQT      =  $("#quantityitems").val();
                    let nameitem    =  $("#name").val();
                    let itemlabel   =  $("#label").val();
                    let weightotal  =  $("#weightotal").val();
                    let checktotal  =  $("#quantitychecker").val();
                    let weight      = weightotal 
                    if(checktotal >= 1 && dropQT >= 1 && dropQT <= checktotal){
                        $.post(`https://${GetParentResourceName()}/drop`, JSON.stringify(
                            {
                                itemname    : nameitem,
                                itemlabel   : itemlabel,
                                dropQT      : dropQT,
                                weight      : parseFloat(weight).toFixed(2)
                            }
                        ));
                        modal.style.display = "none";
                        clear()
                        return;
                    }else{
                        if(dropQT <= 0){
                            $.post(`https://${GetParentResourceName()}/errordrop`, JSON.stringify({}));
                        }else{
                            $.post(`https://${GetParentResourceName()}/errordrop2`, JSON.stringify({}));
                        }
                    }
                })
                $('.clipgun').unbind('click').click(function(){
                    $.post(`https://${GetParentResourceName()}/clipgun`, JSON.stringify({}));
                    clear()
                    return
                })
                $('.inspectweapon').unbind('click').click(function(){
                    $.post(`https://${GetParentResourceName()}/inspectweapon`, JSON.stringify({}));
                    clear()
                    return
                })
                $('.cleangun').unbind('click').click(function(){
                    $.post(`https://${GetParentResourceName()}/cleangun`, JSON.stringify({}));
                    clear()
                    return
                })
                $('.map').unbind('click').click(function(){
                    $.post(`https://${GetParentResourceName()}/map`, JSON.stringify({}));
                    clear()
                    return
                })
            }
            }else{
                clear()
                HideAll()
                document.getElementById("inventory_ui").style.display = "none";
                $("#inventory_ui").hide();
            }
        }
    });

    function HideAll(){
        $("#content_user").html('');
        $("#content_user2").html('');
        $("#content_user3").html('');
        $("#content_user4").html('');
        $("#content_user5").html('');
    }

    function clear(){$("#content_user").html('');}
    document.onkeyup = function (data) {
        if (data.which == 27) {
            HideAll();
            jQuery.post(`https://${GetParentResourceName()}/exit`, JSON.stringify({}));
            return
        }
    };
    $('.closeText').unbind('click').click(function(){
        HideAll();
        jQuery.post(`https://${GetParentResourceName()}/exit`, JSON.stringify({}));
        return
    })
});