$(document).ready(function() {
	$('div.host').each(function(el) {
		var id   = this.id.match(/_(\d+)/)[1];
		var div  = $(this).find('.host_status')
		var spin = $(this).find('.spinner');

		$(div).load("/hosts/"+id+"/status.js", function() {
			spin.hide();
		});
	})
});
