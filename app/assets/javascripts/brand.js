var ready;

ready = function() {
	/* Opening a text-box for manually entering brand_name on clicking Others by Shopkeeper */
	$("#product_brand_id").change(function(){
		if($("#product_brand_id>option:selected").html() == 'Others'){
		  $('#add-brand').show();
		}
		else {
		  $('#add-brand').hide();
		}
	});

	/* Opening a text-box for manually entering category_name on clicking Miscellaneous by Admin */
	$("#product_category_id").change(function(){
		if($("#product_category_id>option:selected").html() == 'Miscellaneous'){
		  $('#add-category').show();
		}
		else {
		  $('#add-category').hide();
		}
	});
};

$(document).ready(ready);
$(document).on('page:load', ready);
