jQuery -> 
	$(window).scroll ->
		url = $('.pagination .next_page a').attr('href')
		if url && ($(window).scrollTop() > $(document).height() - $(window).height() - 100)
			$('.pagination').text("Fetching more products...")
			$.getScript(url)
			
